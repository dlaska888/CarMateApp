<?php

namespace App\Security\Providers;

use App\Entity\CarMateUser;
use App\Repository\CarMateUserRepository;
use Doctrine\ORM\EntityManagerInterface;
use HWI\Bundle\OAuthBundle\OAuth\Response\UserResponseInterface;
use HWI\Bundle\OAuthBundle\Security\Core\User\OAuthAwareUserProviderInterface;
use InvalidArgumentException;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Symfony\Component\Security\Core\Exception\UnsupportedUserException;
use Symfony\Component\Security\Core\User\UserInterface;
use Symfony\Component\Security\Core\User\UserProviderInterface;

class OAuthUserProvider implements UserProviderInterface, OAuthAwareUserProviderInterface

{
    private $property = 'email';

    public function __construct(private EntityManagerInterface $em, private CarMateUserRepository $userRepository)
    {
    }

    public function loadUserByIdentifier(string $identifier): UserInterface
    {
        $user = $this->em->getRepository(CarMateUser::class)->findOneBy([$this->property => $identifier]);

        if (!$user) {
            throw new InvalidArgumentException(sprintf('CarMateUser with %s "%s" not found', $this->property, $identifier));
        }

        return $user;
    }

    public function refreshUser(UserInterface $user): UserInterface
    {
        if (!$user instanceof CarMateUser) {
            throw new UnsupportedUserException(sprintf('Instances of "%s" are not supported.', CarMateUser::class));
        }

        return $this->loadUserByIdentifier($user->getUsername());
    }

    public function loadUserByOAuthUserResponse(UserResponseInterface $response): UserInterface
    {
        $socialID = $response->getUsername();
        $user = $this->userRepository->findOneBy(['google' => $socialID]);
        $email = $response->getEmail();
        $username = $response->getNickname();
        //check if the user already has the corresponding social account
        if (null === $user) {
            //check if the user has a normal account
            $user = $this->userRepository->findOneBy(['email' => $email]);

            if (null === $user || !$user instanceof UserInterface) {
                //if the user does not have a normal account, set it up:
                $user = new CarMateUser();
                $user->setUsername($username);
                $user->setEmail($email);
                $user->setPassword(md5(uniqid('', true)));
            }
            //then set its corresponding social id
            $service = $response->getResourceOwner()->getName();
            switch ($service) {
                case 'google':
                    $user->setGoogle($socialID);
                    break;
            }
            $this->em->persist($user);
            $this->em->flush();
            //$this->userManager->updateUser($user);
        } else {
            //and then login the user
//            $checker = new UserChecker();
//            $checker->checkPreAuth($user);
        }

        return $user;
    }

    /**
     * Tells Symfony to use this provider for this CarMateUser class.
     */
    public function supportsClass($class): bool
    {
        return CarMateUser::class === $class;
    }


}