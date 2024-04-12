<?php

namespace App\Dto\User;

use Symfony\Component\Uid\Uuid;

class GetUserDto
{
    public ?Uuid $id;

    public ?string $username;

    public ?string $email;

    public ?array $roles;

}