<?php

namespace App\Controller;

use App\Dto\Maintenance\CreateMaintenanceDto;
use App\Dto\Maintenance\GetMaintenanceDto;
use App\Dto\Maintenance\UpdateMaintenanceDto;
use App\Entity\Maintenance;
use App\Repository\CarRepository;
use App\Repository\MaintenanceRepository;
use AutoMapperPlus\AutoMapperInterface;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Attribute\MapRequestPayload;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Serializer\Encoder\JsonEncoder;
use Symfony\Component\Serializer\SerializerInterface;
use Symfony\Component\Uid\Uuid;
use OpenApi\Attributes as OA;

#[Route('/api/cars/{carId}/maintenances')]
#[OA\Tag(name: 'Maintenance')]
class MaintenanceController extends AbstractController
{
    public function __construct(
        private readonly CarRepository          $carRepository,
        private readonly MaintenanceRepository  $maintenanceRepository,
        private readonly EntityManagerInterface $entityManager,
        private readonly SerializerInterface    $serializer,
        private readonly AutoMapperInterface    $autoMapper)
    {
    }

    #[Route(methods: ['GET'])]
    public function getAll(Uuid $carId): JsonResponse
    {
        $car = $this->carRepository->find($carId);
        if (!$car) {
            return new JsonResponse('Car not found', Response::HTTP_NOT_FOUND);
        }

        $maintenances = $this->maintenanceRepository->findBy(['car' => $car]);

        $getMaintenancesDtos = $this->autoMapper->mapMultiple($maintenances, GetMaintenanceDto::class);
        $json = $this->serializer->serialize($getMaintenancesDtos, JsonEncoder::FORMAT);

        return new JsonResponse($json, Response::HTTP_OK, json: true);
    }

    #[Route('/{maintenanceId}', methods: ['GET'])]
    public function get(Uuid $carId, Uuid $maintenanceId): JsonResponse
    {
        $car = $this->carRepository->find($carId);
        if (!$car) {
            return new JsonResponse('Car not found', Response::HTTP_NOT_FOUND);
        }

        $maintenance = $this->maintenanceRepository->findOneBy(['id' => $maintenanceId, 'car' => $car]);
        if (!$maintenance) {
            return new JsonResponse('Maintenance not found', Response::HTTP_NOT_FOUND);
        }

        $getMaintenanceDto = $this->autoMapper->map($maintenance, GetMaintenanceDto::class);
        $json = $this->serializer->serialize($getMaintenanceDto, JsonEncoder::FORMAT);

        return new JsonResponse($json, Response::HTTP_OK, json: true);
    }

    #[Route(methods: ['POST'])]
    public function create(Uuid $carId, #[MapRequestPayload]
    CreateMaintenanceDto        $createMaintenanceDto):
    JsonResponse
    {
        $car = $this->carRepository->find($carId);
        if (!$car) {
            return new JsonResponse('Car not found', Response::HTTP_NOT_FOUND);
        }

        $maintenance = $this->autoMapper->map($createMaintenanceDto, Maintenance::class);
        $maintenance->setCar($car);

        $this->entityManager->persist($maintenance);
        $this->entityManager->flush();

        $getMaintenanceDto = $this->autoMapper->map($maintenance, GetMaintenanceDto::class);
        $json = $this->serializer->serialize($getMaintenanceDto, JsonEncoder::FORMAT);

        return new JsonResponse($json, Response::HTTP_OK, json: true);
    }

    #[Route('/{maintenanceId}', methods: ['PUT'])]
    public function update(Uuid $carId, Uuid $maintenanceId, #[MapRequestPayload]
    UpdateMaintenanceDto        $updateMaintenanceDto):
    JsonResponse
    {
        $car = $this->carRepository->find($carId);
        if (!$car) {
            return new JsonResponse('Car not found', Response::HTTP_NOT_FOUND);
        }

        $maintenance = $this->maintenanceRepository->findOneBy(['id' => $maintenanceId, 'car' => $car]);
        if (!$maintenance) {
            return new JsonResponse('Maintenance not found', Response::HTTP_NOT_FOUND);
        }

        $this->autoMapper->mapToObject($updateMaintenanceDto, $maintenance);
        $this->entityManager->flush();

        $getMaintenanceDto = $this->autoMapper->map($maintenance, GetMaintenanceDto::class);
        $json = $this->serializer->serialize($getMaintenanceDto, JsonEncoder::FORMAT);

        return new JsonResponse($json, Response::HTTP_OK, json: true);
    }

    #[Route('/{maintenanceId}', methods: ['DELETE'])]
    public function delete(Uuid $carId, Uuid $maintenanceId): Response
    {
        $car = $this->carRepository->find($carId);
        if (!$car) {
            return new JsonResponse('Car not found', Response::HTTP_NOT_FOUND);
        }

        $maintenance = $this->maintenanceRepository->findOneBy(['id' => $maintenanceId, 'car' => $car]);
        if (!$maintenance) {
            return new JsonResponse('Maintenance not found', Response::HTTP_NOT_FOUND);
        }

        $this->entityManager->remove($maintenance);
        $this->entityManager->flush();

        return new Response(status: Response::HTTP_NO_CONTENT);
    }
}

