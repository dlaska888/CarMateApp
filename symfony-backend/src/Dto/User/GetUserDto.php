<?php

namespace App\Dto\User;

use Symfony\Component\Uid\Uuid;

class GetUserDto
{
    public ?Uuid $id = null;

    public ?string $username = null;

    public ?string $email = null;

    public ?array $roles = null;

}