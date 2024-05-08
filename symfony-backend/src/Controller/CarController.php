<?php

namespace App\Controller;

use App\Dto\Car\CreateCarDto;
use App\Dto\Car\GetCarDto;
use App\Dto\Car\SetCurrentPhotoIdDto;
use App\Dto\Car\UpdateCarDto;
use App\Dto\PagedResultsDto;
use App\Dto\PhotoUploadDto;
use App\Entity\Car;
use App\Entity\CarPhoto;
use App\Repository\CarRepository;
use App\Repository\FileRepository;
use AutoMapperPlus\AutoMapperInterface;
use Doctrine\ORM\EntityManagerInterface;
use Knp\Component\Pager\PaginatorInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\BinaryFileResponse;
use Symfony\Component\HttpFoundation\File\Exception\FileException;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Attribute\MapQueryParameter;
use Symfony\Component\HttpKernel\Attribute\MapRequestPayload;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Serializer\Encoder\JsonEncoder;
use Symfony\Component\Serializer\SerializerInterface;
use Symfony\Component\String\Slugger\SluggerInterface;
use Symfony\Component\Uid\Uuid;
use OpenApi\Attributes as OA;
use Symfony\Component\Validator\Validator\ValidatorInterface;

#[Route('/api/cars')]
#[OA\Tag(name: 'Car')]
class CarController extends AbstractController
{
    public function __construct(
        private readonly CarRepository          $carRepository,
        private readonly EntityManagerInterface $entityManager,
        private readonly AutoMapperInterface    $autoMapper,
        private readonly SerializerInterface    $serializer,
        private readonly PaginatorInterface     $paginator,
        private readonly ValidatorInterface     $validator,
        private readonly SluggerInterface       $slugger,
        private readonly FileRepository         $fileRepository,
    )
    {
    }

    #[Route(methods: ['GET'])]
    public function getAll(#[MapQueryParameter]
                           int $page = 1, #[MapQueryParameter]
                           int $limit = 10): JsonResponse
    {
        $user = $this->getUser();

        $query = $this->entityManager->createQueryBuilder()
            ->select('c')
            ->from('App\Entity\Car', 'c')
            ->where('c.user = :user')
            ->setParameter('user', $user)
            ->getQuery();

        $pagination = $this->paginator->paginate(
            $query,
            $page,
            $limit
        );

        $getCarDtos = $this->autoMapper->mapMultiple($pagination->getItems(), GetCarDto::class);

        $paginatedResult = new PagedResultsDto(
            $getCarDtos,
            $pagination->getTotalItemCount(),
            $pagination->getCurrentPageNumber(),
            $pagination->getItemNumberPerPage(),
        );

        $json = $this->serializer->serialize($paginatedResult, JsonEncoder::FORMAT);

        return new JsonResponse($json, Response::HTTP_OK, json: true);
    }

    #[Route('/{id}', methods: ['GET'])]
    public function get(Uuid $id): JsonResponse
    {
        $car = $this->findCar($id);

        $getCarDto = $this->autoMapper->map($car, GetCarDto::class);
        $json = $this->serializer->serialize($getCarDto, JsonEncoder::FORMAT);

        return new JsonResponse($json, Response::HTTP_CREATED, json: true);
    }

    #[Route(methods: ['POST'])]
    public function create(#[MapRequestPayload]
                           CreateCarDto $createCarDto): JsonResponse
    {
        $car = $this->autoMapper->map($createCarDto, Car::class);
        $car->setUser($this->getUser());

        $this->entityManager->persist($car);
        $this->entityManager->flush();

        $getCarDto = $this->autoMapper->map($car, GetCarDto::class);
        $json = $this->serializer->serialize($getCarDto, JsonEncoder::FORMAT);

        return new JsonResponse($json, Response::HTTP_CREATED, json: true);
    }

    #[Route('/{id}', methods: ['PUT'])]
    public function update(Uuid $id, #[MapRequestPayload]
    UpdateCarDto                $updateCarDto): JsonResponse
    {
        $car = $this->findCar($id);

        $this->autoMapper->mapToObject($updateCarDto, $car);
        $this->entityManager->flush();

        $getCarDto = $this->autoMapper->map($car, GetCarDto::class);
        $json = $this->serializer->serialize($getCarDto, JsonEncoder::FORMAT);

        return new JsonResponse($json, Response::HTTP_CREATED, json: true);
    }

    #[Route('/{id}', methods: ['DELETE'])]
    public function delete(Uuid $id): Response
    {
        $car = $this->findCar($id);

        $this->entityManager->remove($car);
        $this->entityManager->flush();

        return new Response(status: Response::HTTP_NO_CONTENT);
    }

    #[Route('/{carId}/photos/{photoId}', methods: ['GET'])]
    public function getPhoto(Uuid $carId, Uuid $photoId): Response
    {
        $car = $this->findCar($carId);
        $photo = $this->findPhoto($carId, $photoId);
        $path = $this->getParameter('car_photos_directory') . '/' . $car->getId() . '/' . $photo->getName();

        return new BinaryFileResponse($path, Response::HTTP_OK);
    }

    #[Route('/{id}/photos', methods: ['POST'])]
    public function uploadPhoto(Request $request, Uuid $id): JsonResponse
    {
        $car = $this->findCar($id);

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
                $this->getParameter('car_photos_directory') . '/' . $car->getId(),
                $newFilename
            );
        } catch (FileException) {
            return new JsonResponse('Failed to upload photo', Response::HTTP_INTERNAL_SERVER_ERROR);
        }

        $file = new CarPhoto();
        $file->setName($newFilename);
        $file->setCar($car);
        $this->entityManager->persist($file);

        $car->addPhoto($file);
        if (!$car->getCurrentPhoto()) {
            $car->setCurrentPhoto($file);
        }
        $this->entityManager->flush();

        return new JsonResponse($file->getId(), Response::HTTP_OK);
    }

    #[Route('/{carId}/currentPhoto', methods: ['POST'])]
    public function setCurrentPhoto(Uuid $carId, #[MapRequestPayload]
    SetCurrentPhotoIdDto                 $dto): JsonResponse
    {
        $car = $this->findCar($carId);
        $photo = $this->findPhoto($carId, $dto->photoId);

        if ($car->getCurrentPhoto()?->getId()->equals($dto->photoId)) {
            return new JsonResponse('Photo already set as current', Response::HTTP_BAD_REQUEST);
        }

        $car->setCurrentPhoto($photo);
        $this->entityManager->flush();

        return new JsonResponse('Current photo set', Response::HTTP_OK);
    }

    #[Route('/{carId}/photos/{photoId}', methods: ['DELETE'])]
    public function deletePhoto(Uuid $carId, Uuid $photoId): Response
    {
        $car = $this->findCar($carId);
        $photo = $this->findPhoto($carId, $photoId);

        $path = $this->getParameter('car_photos_directory') . '/' . $car->getId() . '/' . $photo->getName();
        unlink($path);

        $this->entityManager->remove($photo);
        $car->removePhoto($photo);

        $currentPhotoId = $car->getCurrentPhoto()?->getId();
        if ($currentPhotoId?->equals($photoId)) {
            if ($car->getPhotos()->count() > 1) {
                $car->setCurrentPhoto($currentPhotoId->equals($car->getPhotos()->first()->getId())
                    ? $car->getPhotos()[1]
                    : $car->getPhotos()[0]);
            } else {
                $car->setCurrentPhoto(null);
            }
        }
        
        $this->entityManager->flush();

        return new Response(status: Response::HTTP_NO_CONTENT);
    }

    private function findCar(Uuid $id): Car
    {
        $car = $this->carRepository->find($id);
        if (!$car) {
            throw $this->createNotFoundException('Car not found');
        }

        return $car;
    }

    private function findPhoto(Uuid $carId, Uuid $photoId): CarPhoto
    {
        $car = $this->carRepository->find($carId);
        if (!$car) {
            throw $this->createNotFoundException('Car not found');
        }

        $photo = $this->fileRepository->find($photoId);
        if (!$photo) {
            throw $this->createNotFoundException('Photo not found');
        }

        return $photo;
    }
}
