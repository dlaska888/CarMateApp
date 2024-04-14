<?php

namespace App\Dto\Maintenance;

use DateTimeInterface;
use Symfony\Component\Validator\Constraints as Assert;

class UpdateMaintenanceDto
{
    #[Assert\Length(min: 2, max: 50)]
    public ?string $name;

    #[Assert\Length(max: 255)]
    public ?string $description;

    #[Assert\PositiveOrZero]
    public ?int $dueMileage;

    #[Assert\Type(type: 'DateTimeInterface')]
    public ?DateTimeInterface $dueDate;

    #[Assert\PositiveOrZero]
    public ?string $cost;
    
}