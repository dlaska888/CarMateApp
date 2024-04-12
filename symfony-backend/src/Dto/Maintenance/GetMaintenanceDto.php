<?php

namespace App\Dto\Maintenance;

use DateTimeInterface;
use Symfony\Component\Uid\Uuid;

class GetMaintenanceDto
{
    public ?Uuid $id;
    
    public ?string $name;

    public ?string $description;

    public ?int $dueMileage;

    public ?DateTimeInterface $dueDate;

    public ?string $cost;

}