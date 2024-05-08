<?php

namespace App\Dto\Maintenance;

use DateTimeInterface;
use Symfony\Component\Uid\Uuid;

class GetMaintenanceDto
{
    public ?Uuid $id = null;
    
    public ?string $name = null;

    public ?string $description = null;

    public ?int $dueMileage = null;

    public ?DateTimeInterface $dueDate = null;

    public ?string $cost = null;

}