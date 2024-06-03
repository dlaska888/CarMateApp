<?php

namespace App\Controller;

use App\Dto\User\GetUserDto;
use App\Dto\User\UpdateUserDto;
use App\Repository\CarMateUserRepository;
use AutoMapperPlus\AutoMapperInterface;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Attribute\MapRequestPayload;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Uid\Uuid;
use Twig\Environment;
use OpenApi\Attributes as OA;

#[Route('/admin/users')]
#[OA\Tag(name: 'Admin', description: 'Admin operations on users')]
class AdminUserController extends AbstractController
{
    function __construct(
        private EntityManagerInterface $entityManager,
        private CarMateUserRepository  $userRepository,
        private AutoMapperInterface    $mapper,
        private Environment            $twig
    )
    {
    }

    #[Route(name: 'user_index', methods: ['GET'])]
    public function getAll(): Response
    {
        $users = $this->userRepository->findAll();
        $dtos = $this->mapper->mapMultiple($users, GetUserDto::class);

        return new Response($this->twig->render('admin/user_index.html.twig', [
            'users' => $dtos,
        ]));
    }

    #[Route('/{id}', name: 'user_show', methods: ['GET'])]
    public function get(Uuid $id): Response
    {
        $user = $this->userRepository->find($id);
        if (!$user) {
            throw $this->createNotFoundException('User not found');
        }

        $dto = $this->mapper->map($user, GetUserDto::class);

// Render the template with the user data
        return new Response($this->twig->render('admin/user_show.html.twig', [
            'user' => $dto, 'editable' => $user->getId() !== $this->getUser()->getId()
        ]));
    }

    #[Route('/{id}/edit', name: 'user_edit', methods: ['GET', 'POST'])]
    public function update(Request $request, Uuid $id): Response
    {
        $user = $this->userRepository->find($id);
        if (!$user) {
            throw $this->createNotFoundException('User not found');
        }

        if ($request->isMethod('POST')) {
            if ($user->getId() === $this->getUser()->getId()) {
                throw $this->createAccessDeniedException('You cannot edit your own user');
            }
            
            $user->setUsername($request->request->get('username'));
            $user->setEmail($request->request->get('email'));
            $user->setRoles([$request->request->get('roles')]); 

            $this->entityManager->persist($user);
            $this->entityManager->flush();

            return $this->redirectToRoute('user_show', ['id' => $id]);
        }

        return $this->render('admin/user_edit.html.twig', [
            'user' => $user,
        ]);
    }

    #[Route('/{id}', name: 'user_delete', methods: ['DELETE'])]
    public function delete(Uuid $id): Response
    {
        $user = $this->userRepository->find($id);

        if (!$user) {
            throw $this->createNotFoundException('User not found');
        }

        $this->entityManager->remove($user);
        $this->entityManager->flush();

        return $this->redirectToRoute('user_index');
    }
}
