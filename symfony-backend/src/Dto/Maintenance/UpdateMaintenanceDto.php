<?php

namespace App\Dto\Maintenance;

use DateInterval;
use DateTimeInterface;
use Symfony\Component\Validator\Constraints as Assert;

class UpdateMaintenanceDto
{
    #[Assert\Length(min: 2, max: 50)]
    public ?string $name = null;

    #[Assert\Length(max: 255)]
    public ?string $description = null;

    #[Assert\PositiveOrZero]
    public ?int $dueMileage = null;

    #[Assert\PositiveOrZero]
    #[Assert\LessThan(10000000)]
    public ?int $mileageInterval = null;

    #[Assert\Type(type: 'DateTimeInterface')]
    public ?DateTimeInterface $dueDate = null;

    #[Assert\Type(type: 'DateInterval')]
    public ?DateInterval $dateInterval = null;

    #[Assert\PositiveOrZero]
    public ?string $cost = null;
    
}