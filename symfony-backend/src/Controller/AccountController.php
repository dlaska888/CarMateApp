<?php

namespace App\Controller;

use App\Dto\User\GetUserDto;
use App\Repository\CarMateUserRepository;
use AutoMapperPlus\AutoMapperInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Serializer\SerializerInterface;

#[Route('/api/account')]
class AccountController extends AbstractController
{
    public function __construct(
        private readonly CarMateUserRepository $userRepository,
        private readonly AutoMapperInterface $autoMapper,
        private readonly SerializerInterface $serializer
    ){}

    #[Route('/me', methods: ['GET'])]
    public function getAccount(): JsonResponse
    {
        $user = $this->getUser();
        $dto = $this->autoMapper->map($user, GetUserDto::class);
        $json = $this->serializer->serialize($dto, 'json');

        return new JsonResponse($json, json: true);
    }

}