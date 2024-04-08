<?php

namespace App\Controller;

use App\Dto\UserRegisterDto;
use App\Entity\CarMateUser;
use AutoMapperPlus\AutoMapperInterface;
use Doctrine\ORM\EntityManagerInterface;
use Lexik\Bundle\JWTAuthenticationBundle\Services\JWTTokenManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Exception\BadRequestException;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Attribute\MapRequestPayload;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Routing\Attribute\Route;

#[Route(path: '/api', name: 'api_')]
class SecurityController extends AbstractController
{
    private UserPasswordHasherInterface $userPasswordHasher;
    private EntityManagerInterface $entityManager;
    private JWTTokenManagerInterface $JWTManager;
    private AutoMapperInterface $autoMapper;

    public function __construct(
        UserPasswordHasherInterface $userPasswordHasher,
        EntityManagerInterface      $entityManager,
        JWTTokenManagerInterface    $JWTManager,
        AutoMapperInterface         $autoMapper
    )
    {
        $this->userPasswordHasher = $userPasswordHasher;
        $this->entityManager = $entityManager;
        $this->JWTManager = $JWTManager;
        $this->autoMapper = $autoMapper;
    }

    #[Route('/register', name: 'app_register')]
    public function register(#[MapRequestPayload]
                             UserRegisterDto $registerDto): Response
    {
        $find = $this->entityManager
            ->getRepository(CarMateUser::class)
            ->findBy(["email" => $registerDto->getEmail()]);

        if ($find) {
            throw new BadRequestException("User already exists");
        }

        $user = $this->autoMapper->map($registerDto, CarMateUser::class);
        $user->setPassword(
            $this->userPasswordHasher->hashPassword(
                $user,
                $registerDto->getPassword()
            )
        );

        $this->entityManager->persist($user);
        $this->entityManager->flush();

        $token = $this->JWTManager->create($user);

        return new JsonResponse($token, Response::HTTP_CREATED);
    }

    #[Route(path: '/logout', name: 'app_logout')]
    public function logout(): JsonResponse
    {
        $user = $this->getUser();
        return new JsonResponse($user->getUserIdentifier());
    }
}
