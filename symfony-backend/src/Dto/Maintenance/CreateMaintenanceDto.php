<?php

namespace App\Dto\Maintenance;

use DateTimeInterface;
use Symfony\Component\Validator\Constraints as Assert;

class CreateMaintenanceDto
{
    #[Assert\NotBlank]
    #[Assert\Length(min: 2, max: 50)]
    public ?string $name = null;

    #[Assert\Length(max: 255)]
    public ?string $description = null;

    #[Assert\PositiveOrZero]
    public ?int $dueMileage = null;

    #[Assert\Type(type: 'DateTimeInterface')]
    public ?DateTimeInterface $dueDate = null;

    #[Assert\PositiveOrZero]
    public ?string $cost = null;

}