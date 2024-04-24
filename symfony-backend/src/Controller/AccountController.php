<?php

namespace App\Controller;

use App\Dto\PhotoUploadDto;
use App\Dto\User\GetUserDto;
use App\Dto\User\ChangePasswordDto;
use App\Dto\User\ChangeUsernameDto;
use App\Entity\File;
use App\Repository\CarMateUserRepository;
use AutoMapperPlus\AutoMapperInterface;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\BinaryFileResponse;
use Symfony\Component\HttpFoundation\File\Exception\FileException;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Attribute\MapRequestPayload;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Serializer\Encoder\JsonEncoder;
use Symfony\Component\Serializer\SerializerInterface;
use Symfony\Component\String\Slugger\SluggerInterface;
use OpenApi\Attributes as OA;
use Symfony\Component\Validator\Validator\ValidatorInterface;

#[Route('/api/account')]
#[OA\Tag(name: 'Account')]
class AccountController extends AbstractController
{
    public function __construct(
        private readonly CarMateUserRepository  $userRepository,
        private readonly AutoMapperInterface    $autoMapper,
        private readonly SerializerInterface    $serializer,
        private readonly EntityManagerInterface $entityManager,
        private readonly SluggerInterface       $slugger,
        private readonly ValidatorInterface     $validator,
        private readonly UserPasswordHasherInterface $passwordHasher
    )
    {
    }

    #[Route('/me', methods: ['GET'])]
    public function getAccount(): JsonResponse
    {
        $user = $this->getUser();
        $dto = $this->autoMapper->map($user, GetUserDto::class);
        $json = $this->serializer->serialize($dto, 'json');

        return new JsonResponse($json, json: true);
    }

    #[Route('/change-username', methods: ['POST'])]
    public function changeUsername(#[MapRequestPayload] ChangeUsernameDto $dto): JsonResponse
    {
        if($this->userRepository->findBy(['username' => $dto->username])){
            return new JsonResponse('Username already taken', Response::HTTP_CONFLICT);
        }

        $user = $this->getUser();
        $user->setUsername($dto->username);
        $this->entityManager->flush();

        return new JsonResponse('Username updated', Response::HTTP_OK);
    }

    #[Route('/change-password', methods: ['POST'])]
    public function changePassword(#[MapRequestPayload] ChangePasswordDto $dto): JsonResponse
    {
        $user = $this->getUser();

        if (!$this->passwordHasher->isPasswordValid($user, $dto->password)){
            return new JsonResponse('Password is incorrect', Response::HTTP_BAD_REQUEST);
        }

        $user->setPassword($dto->newPassword);
        $this->entityManager->flush();

        return new JsonResponse('Password updated', Response::HTTP_OK);
    }

    #[Route('/profile-photo', methods: ['GET'])]
    public function getPhoto(): Response
    {
        $user = $this->getUser();
        $photo = $user->getPhoto();
        if (!$photo) {
            return new JsonResponse('No photo uploaded', Response::HTTP_NOT_FOUND);
        }

        $path = $this->getParameter('user_photos_directory') . '/' . $photo->getName();
        return new BinaryFileResponse($path, Response::HTTP_OK);
    }

    #[Route('/profile-photo', methods: ['POST'])]
    public function uploadPhoto(Request $request): JsonResponse
    {
        $photoUploadDto = new PhotoUploadDto();
        $photoUploadDto->photo = $request->files->get('photo');

        $errors = $this->validator->validate($photoUploadDto);

        if (count($errors) > 0) {
            return new JsonResponse($this->serializer->serialize($errors, JsonEncoder::FORMAT), Response::HTTP_BAD_REQUEST, json: true);
        }

        $originalFilename = pathinfo($photoUploadDto->photo->getClientOriginalName(), PATHINFO_FILENAME);
        $safeFilename = $this->slugger->slug($originalFilename);
        $newFilename = $safeFilename . '-' . uniqid() . '.' . $photoUploadDto->photo->guessExtension();

        try {
            $photoUploadDto->photo->move(
                $this->getParameter('user_photos_directory'),
                $newFilename
            );
        } catch (FileException) {
            return new JsonResponse('Failed to upload photo', Response::HTTP_INTERNAL_SERVER_ERROR);
        }

        $file = new File();
        $file->setName($newFilename);
        $this->entityManager->persist($file);

        $user = $this->getUser();
        $user->setPhoto($file);
        $this->entityManager->flush();

        return new JsonResponse('Photo uploaded', Response::HTTP_OK);
    }

    #[Route('/profile-photo', methods: ['DELETE'])]
    public function deletePhoto(): JsonResponse
    {
        $user = $this->getUser();
        $photo = $user->getPhoto();
        if (!$photo) {
            return new JsonResponse('No photo uploaded', Response::HTTP_NOT_FOUND);
        }

        $path = $this->getParameter('user_photos_directory') . '/' . $photo->getName();
        unlink($path);

        $this->entityManager->remove($photo);
        $user->setPhoto(null);
        $this->entityManager->flush();

        return new JsonResponse('Photo deleted', Response::HTTP_OK);
    }


}