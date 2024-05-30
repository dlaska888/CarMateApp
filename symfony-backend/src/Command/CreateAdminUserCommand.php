<?php

namespace App\Command;

use App\Entity\CarMateUser;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

#[AsCommand(name: 'app:create-admin-user', description: 'Create admin CarMate user')]
class CreateAdminUserCommand extends Command
{
    private EntityManagerInterface $entityManager;
    private UserPasswordHasherInterface $userPasswordHasher;

    public function __construct(EntityManagerInterface $entityManager, UserPasswordHasherInterface $passwordEncoder)
    {
        $this->entityManager = $entityManager;
        $this->userPasswordHasher = $passwordEncoder;

        parent::__construct();
    }

    protected function configure()
    {
        $this
            ->setDescription('Creates a new admin user')
            ->addArgument('username', InputArgument::REQUIRED, 'The username of the admin')
            ->addArgument('password', InputArgument::REQUIRED, 'The password of the admin')
            ->addArgument('email', InputArgument::REQUIRED, 'The email of the admin');
    }

    protected function execute(InputInterface $input, OutputInterface $output) : int
    {
        $username = $input->getArgument('username');
        $password = $input->getArgument('password');
        $email = $input->getArgument('email');

        $existingUser = $this->entityManager->getRepository(CarMateUser::class)->findOneBy(['username' => $username]);
        if ($existingUser) {
            $output->writeln('User already exists!');
            return Command::SUCCESS;
        }

        $user = new CarMateUser();
        $user->setUsername($username);
        $user->setPassword($this->userPasswordHasher->hashPassword($user, $password));
        $user->setEmail($email);
        $user->setRoles(['ROLE_ADMIN']); // Assign the admin role
        $user->setIsEmailConfirmed(true);

        $this->entityManager->persist($user);
        $this->entityManager->flush();

        $output->writeln('Admin user created successfully!');

        return Command::SUCCESS;
    }
}
