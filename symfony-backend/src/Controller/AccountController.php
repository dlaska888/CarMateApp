<?php

namespace App\Controller;

use App\Dto\PhotoUploadDto;
use App\Dto\User\GetUserDto;
use App\Dto\User\ChangePasswordDto;
use App\Dto\User\ChangeUsernameDto;
use App\Entity\CarMateUser;
use App\Entity\UserPhoto;
use App\Repository\CarMateUserRepository;
use App\Repository\FileRepository;
use AutoMapperPlus\AutoMapperInterface;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\BinaryFileResponse;
use Symfony\Component\HttpFoundation\Exception\BadRequestException;
use Symfony\Component\HttpFoundation\File\Exception\FileException;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Attribute\MapRequestPayload;
use Symfony\Component\HttpKernel\Exception\ConflictHttpException;
use Symfony\Component\HttpKernel\Exception\HttpException;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Serializer\Encoder\JsonEncoder;
use Symfony\Component\Serializer\SerializerInterface;
use Symfony\Component\String\Slugger\SluggerInterface;
use OpenApi\Attributes as OA;
use Symfony\Component\Uid\Uuid;
use Symfony\Component\Validator\Validator\ValidatorInterface;

#[Route('/api/account')]
#[OA\Tag(name: 'Account')]
class AccountController extends AbstractController
{
    public function __construct(
        private readonly CarMateUserRepository       $userRepository,
        private readonly AutoMapperInterface         $autoMapper,
        private readonly SerializerInterface         $serializer,
        private readonly EntityManagerInterface      $entityManager,
        private readonly SluggerInterface            $slugger,
        private readonly ValidatorInterface          $validator,
        private readonly UserPasswordHasherInterface $passwordHasher,
        private readonly FileRepository              $fileRepository,
    )
    {
    }

    #[Route('/me', methods: ['GET'])]
    public function getAccount(): JsonResponse
    {
        /** @var CarMateUser $user */
        $user = $this->getUser();
        $dto = $this->autoMapper->map($user, GetUserDto::class);
        $json = $this->serializer->serialize($dto, 'json');

        return new JsonResponse($json, json: true);
    }

    #[Route('/change-username', methods: ['POST'])]
    public function changeUsername(#[MapRequestPayload]
                                   ChangeUsernameDto $dto): JsonResponse
    {
        if ($this->userRepository->findBy(['username' => $dto->username])) {
            throw new ConflictHttpException('Username already taken');
        }

        /** @var CarMateUser $user */
        $user = $this->getUser();

        if (!$this->passwordHasher->isPasswordValid($user, $dto->password)) {
            throw new BadRequestException('Password is incorrect');
        }

        $user->setUsername($dto->username);
        $this->entityManager->flush();

        return new JsonResponse('Username updated', Response::HTTP_OK);
    }

    #[Route('/change-password', methods: ['POST'])]
    public function changePassword(#[MapRequestPayload]
                                   ChangePasswordDto $dto): JsonResponse
    {
        /** @var CarMateUser $user */
        $user = $this->getUser();

        if (!$this->passwordHasher->isPasswordValid($user, $dto->password)) {
            throw new BadRequestException('Password is incorrect');
        }

        $user->setPassword(
            $this->passwordHasher->hashPassword(
                $user,
                $dto->newPassword
            )
        );
        $this->entityManager->flush();

        return new JsonResponse('Password updated', Response::HTTP_OK);
    }

    #[Route('/profile-photo/{profilePhotoId}', methods: ['GET'])]
    public function getPhoto(Uuid $profilePhotoId): Response
    {
        $user = $this->getUser();

        if (!$user->getPhoto()) {
            throw new BadRequestException('No photo uploaded');
        }

        $photo = $this->fileRepository->find($profilePhotoId);
        if (!$photo) {
            throw new NotFoundHttpException('No photo found');
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

        /* @var CarMateUser $user */
        $user = $this->getUser();
        if ($user->getPhoto()) {
            $this->removePhoto($user);
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
            throw new HttpException(Response::HTTP_INTERNAL_SERVER_ERROR);
        }

        $file = new UserPhoto();
        $file->setName($newFilename);
        $this->entityManager->persist($file);

        $user = $this->getUser();
        $user->setPhoto($file);
        $this->entityManager->flush();

        return new JsonResponse($file->getId(), Response::HTTP_OK);
    }

    #[Route('/profile-photo', methods: ['DELETE'])]
    public function deletePhoto(): JsonResponse
    {
        /* @var CarMateUser $user */
        $user = $this->getUser();
        $photo = $user->getPhoto();
        if (!$photo) {
            throw new BadRequestException('No photo uploaded');
        }

        $this->removePhoto($user);

        return new JsonResponse('Photo deleted', Response::HTTP_OK);
    }

    private function removePhoto(CarMateUser $user): void
    {
        $photo = $user->getPhoto();
        if ($photo) {
            $path = $this->getParameter('user_photos_directory') . '/' . $photo->getName();
            unlink($path);

            $this->entityManager->remove($photo);
            $user->setPhoto(null);
            $this->entityManager->flush();
        }
    }

}