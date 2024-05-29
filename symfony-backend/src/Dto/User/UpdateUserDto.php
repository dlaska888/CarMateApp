<?php

namespace App\Dto\User;

class UpdateUserDto
{
    public string $username;
    public string $email;
    public array $roles;
}