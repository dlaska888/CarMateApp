<?php

namespace App\Dto\Car;

use DateTimeInterface;
use Symfony\Component\Uid\Uuid;

class GetCarDto
{
    public ?Uuid $id = null;

    public ?string $name = null;

    public ?string $model = null;

    public ?string $brand = null;

    public ?float $displacement = null;

    public ?DateTimeInterface $productionDate = null;

    public ?int $mileage = null;

    public ?DateTimeInterface $purchaseDate = null;

    public ?string $plate = null;

    public ?string $vin = null;
    
    public ?Uuid $currentPhotoId = null;

    public array $maintenances;
    
    public array $photosIds;
}
