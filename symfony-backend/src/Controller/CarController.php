<?php

namespace App\Controller;

use App\Dto\Car\CreateCarDto;
use App\Dto\Car\GetCarDto;
use App\Dto\Car\UpdateCarDto;
use App\Dto\PagedResultsDto;
use App\Entity\Car;
use App\Repository\CarRepository;
use AutoMapperPlus\AutoMapperInterface;
use Doctrine\ORM\EntityManagerInterface;
use Knp\Component\Pager\PaginatorInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Attribute\MapQueryParameter;
use Symfony\Component\HttpKernel\Attribute\MapRequestPayload;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Serializer\Encoder\JsonEncoder;
use Symfony\Component\Serializer\SerializerInterface;
use Symfony\Component\Uid\Uuid;

#[Route('/api/cars')]
class CarController extends AbstractController
{
    private CarRepository $carRepository;
    private EntityManagerInterface $entityManager;
    private AutoMapperInterface $autoMapper;
    private SerializerInterface $serializer;
    private PaginatorInterface $paginator;

    public function __construct(
        CarRepository $carRepository,
        EntityManagerInterface $entityManager,
        AutoMapperInterface $autoMapper,
        SerializerInterface $serializer,
        PaginatorInterface $paginator
    ) {
        $this->carRepository = $carRepository;
        $this->entityManager = $entityManager;
        $this->autoMapper = $autoMapper;
        $this->serializer = $serializer;
        $this->paginator = $paginator;
    }

    #[Route(methods: ['GET'])]
    public function getAll(#[MapQueryParameter] int $page = 1, #[MapQueryParameter] int $limit = 10): JsonResponse
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
        $car = $this->carRepository->find($id);
        if (!$car) {
            return new JsonResponse('Car not found', Response::HTTP_NOT_FOUND);
        }

        $getCarDto = $this->autoMapper->map($car, GetCarDto::class);
        $json = $this->serializer->serialize($getCarDto, JsonEncoder::FORMAT);

        return new JsonResponse($json, Response::HTTP_CREATED, json: true);
    }

    #[Route(methods: ['POST'])]
    public function create(#[MapRequestPayload] CreateCarDto $createCarDto): JsonResponse
    {
        $car = $this->autoMapper->map($createCarDto, Car::class);
        $car->setUser($this->getUser());

        $this->entityManager->persist($car);
        $this->entityManager->flush();
        
        $getCarDto = $this->autoMapper->map($car, GetCarDto::class);
        $json = $this->serializer->serialize($getCarDto, JsonEncoder::FORMAT);

        return new JsonResponse($json, Response::HTTP_CREATED, json: true);
    }

    #[Route('/{id}',methods: ['PUT'])]
    public function update(Uuid $id, #[MapRequestPayload] UpdateCarDto $updateCarDto): JsonResponse
    {
        $car = $this->carRepository->find($id);
        if (!$car) {
            return new JsonResponse('Car not found', Response::HTTP_NOT_FOUND);
        }

        $this->autoMapper->mapToObject($updateCarDto, $car);
        $this->entityManager->flush();

        $getCarDto = $this->autoMapper->map($car, GetCarDto::class);
        $json = $this->serializer->serialize($getCarDto, JsonEncoder::FORMAT);

        return new JsonResponse($json, Response::HTTP_CREATED, json: true);
    }

    #[Route('/{id}', methods: ['DELETE'])]
    public function delete(Uuid $id): Response
    {
        $car = $this->carRepository->find($id);
        if (!$car) {
            return new JsonResponse('Car not found', Response::HTTP_NOT_FOUND);
        }

        $this->entityManager->remove($car);
        $this->entityManager->flush();

        return new Response(status: Response::HTTP_OK);
    }
}
