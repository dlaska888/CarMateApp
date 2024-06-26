<?php

namespace App\Controller;

use App\Dto\Security\GetTokenDto;
use App\Dto\Security\GoogleLoginDto;
use App\Dto\Security\UserRegisterDto;
use App\Entity\CarMateUser;
use App\Repository\CarMateUserRepository;
use App\Service\EmailService;
use App\Service\JwtTokenService;
use AutoMapperPlus\AutoMapperInterface;
use Doctrine\ORM\EntityManagerInterface;
use Google_Client;
use OpenApi\Attributes as OA;
use Ramsey\Uuid\Rfc4122\UuidV8;
use Ramsey\Uuid\Uuid;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\DependencyInjection\ParameterBag\ContainerBagInterface;
use Symfony\Component\HttpFoundation\Exception\BadRequestException;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Attribute\MapRequestPayload;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Serializer\Encoder\JsonEncoder;
use Symfony\Component\Serializer\SerializerInterface;

#[Route(path: '/api', name: 'api_')]
#[OA\Tag(name: 'Security')]
#[OA\Response(response: '500', description: 'Internal server error')]
class SecurityController extends AbstractController
{
    public function __construct(
        private readonly UserPasswordHasherInterface $userPasswordHasher,
        private readonly EntityManagerInterface      $entityManager,
        private readonly CarMateUserRepository       $userRepository,
        private readonly JwtTokenService             $jwtTokenService,
        private readonly SerializerInterface         $serializer,
        private readonly AutoMapperInterface         $autoMapper,
        private readonly ContainerBagInterface       $containerBag,
        private readonly EmailService                $emailService
    )
    {
    }

    #[Route('/login-google', name: 'app_google_login', methods: ['POST'])]
    public function loginGoogle(#[MapRequestPayload] GoogleLoginDto $dto): Response
    {
        $client = new Google_Client(['client_id' => $this->containerBag->get('google_id')]);
        $payload = $client->verifyIdToken($dto->idToken);

        if (!$payload) {
            throw new BadRequestException("Invalid token");
        }

        $user = $this->userRepository->findOneBy(["google" => $payload['sub']]);

        if ($user) {
            $json = $this->serializer->serialize($this->jwtTokenService->GenerateTokenAndRefreshForUser($user),
                JsonEncoder::FORMAT);
            return new JsonResponse($json, json: true);
        }

        if (!isset($payload['email'])) {
            throw new BadRequestException("Invalid token, email not found in payload");
        }

        $user = $this->userRepository->findOneBy(["email" => $payload['email']]);

        if ($user) {
            $user->setGoogle($payload['sub']);
            $this->entityManager->persist($user);
            $this->entityManager->flush();

            $json = $this->serializer->serialize($this->jwtTokenService->GenerateTokenAndRefreshForUser($user),
                JsonEncoder::FORMAT);
            return new JsonResponse($json, json: true);
        }

        if (!isset($payload['name'])) {
            throw new BadRequestException("Invalid token, name not found in payload");
        }

        $user = new CarMateUser();
        $user->setGoogle($payload['sub']);
        $user->setEmail($payload['email']);
        $user->setUsername($payload['name']);
        $user->setPassword($this->userPasswordHasher->hashPassword($user, bin2hex(random_bytes(16))));
        $user->setIsEmailConfirmed($payload['email_verified'] ?? false);
        $this->entityManager->persist($user);
        $this->entityManager->flush();

        if (!$user->getIsEmailConfirmed()) {
            $user->setConfirmationToken(Uuid::uuid6()->toString());
        }

        $this->entityManager->persist($user);
        $this->entityManager->flush();

        if (!$user->getIsEmailConfirmed()) {
            $this->emailService->sendConfirmationEmail($user->getEmail(), $user->getUsername(), $user->getConfirmationToken());
        }

        $json = $this->serializer->serialize($this->jwtTokenService->GenerateTokenAndRefreshForUser($user),
            JsonEncoder::FORMAT);

        return new JsonResponse($json, json: true);
    }


    #[Route('/register', name: 'app_register', methods: ['POST'])]
    #[OA\Response(response: '201', description: 'User registered', content: new OA\JsonContent(type: GetTokenDto::class))]
    #[OA\Response(response: '400', description: 'Bad request')]
    public function register(#[MapRequestPayload]
                             UserRegisterDto $registerDto): Response
    {
        $find = $this->entityManager
            ->getRepository(CarMateUser::class)
            ->findBy(["email" => $registerDto->email]);

        if ($find) {
            throw new BadRequestException("User already exists");
        }

        $find = $this->entityManager
            ->getRepository(CarMateUser::class)
            ->findBy(["username" => $registerDto->username]);

        if ($find) {
            throw new BadRequestException("User already exists");
        }

        $user = $this->autoMapper->map($registerDto, CarMateUser::class);
        $user->setPassword(
            $this->userPasswordHasher->hashPassword(
                $user,
                $registerDto->password
            )
        );

        $this->entityManager->persist($user);
        $this->entityManager->flush();

        $this->emailService->sendConfirmationEmail($user->getEmail(), $user->getUsername(), $user->getConfirmationToken());

        $json = $this->serializer->serialize($this->jwtTokenService->GenerateTokenAndRefreshForUser($user),
            JsonEncoder::FORMAT);
        return new JsonResponse($json, Response::HTTP_CREATED, json: true);
    }
    
    #[Route('/resend-confirmation-email', name: 'resend_confirmation_email', methods: ['POST'])]
    public function resendConfirmationEmail(): Response
    {
        /** @var CarMateUser $user */
        $user = $this->getUser();
        
        if ($user->getIsEmailConfirmed()) {
            throw new BadRequestException("Email already confirmed");
        }
        
        $this->emailService->sendConfirmationEmail($user->getEmail(), $user->getUsername(), $user->getConfirmationToken());
        
        return new JsonResponse("Email sent", Response::HTTP_OK);
    }

    #[Route('/confirm-email/{token}', name: 'confirm_email', methods: ['GET'])]
    public function confirm(string $token): Response
    {
        $user = $this->userRepository->findOneBy(['confirmationToken' => $token]);

        if (!$user) {
            return new RedirectResponse($this->containerBag->get('frontend_url') . '/login');
        }

        $user->setIsEmailConfirmed(true);
        $user->setConfirmationToken(null);

        $this->entityManager->flush();

        return new RedirectResponse($this->containerBag->get('frontend_url') . '/login');
    }

}
