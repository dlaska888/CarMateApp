<?php

namespace App\Dto\Car;

use DateTimeInterface;
use Symfony\Component\Uid\Uuid;

class GetCarDto
{
    private ?Uuid $id;
    private ?string $name;

    private ?string $model;

    private ?string $brand;

    private ?float $displacement;

    private ?DateTimeInterface $productionDate;

    private ?int $mileage;

    private ?DateTimeInterface $purchaseDate;

    private ?string $plate;

    private ?string $VIN;

    public function getId(): ?Uuid
    {
        return $this->id;
    }

    public function setId(?Uuid $id): void
    {
        $this->id = $id;
    }

    public function getName(): ?string
    {
        return $this->name;
    }

    public function setName(?string $name): void
    {
        $this->name = $name;
    }

    public function getModel(): ?string
    {
        return $this->model;
    }

    public function setModel(?string $model): void
    {
        $this->model = $model;
    }

    public function getBrand(): ?string
    {
        return $this->brand;
    }

    public function setBrand(?string $brand): void
    {
        $this->brand = $brand;
    }

    public function getDisplacement(): ?float
    {
        return $this->displacement;
    }

    public function setDisplacement(?float $displacement): void
    {
        $this->displacement = $displacement;
    }

    public function getProductionDate(): ?DateTimeInterface
    {
        return $this->productionDate;
    }

    public function setProductionDate(?DateTimeInterface $productionDate): void
    {
        $this->productionDate = $productionDate;
    }

    public function getMileage(): ?int
    {
        return $this->mileage;
    }

    public function setMileage(?int $mileage): void
    {
        $this->mileage = $mileage;
    }

    public function getPurchaseDate(): ?DateTimeInterface
    {
        return $this->purchaseDate;
    }

    public function setPurchaseDate(?DateTimeInterface $purchaseDate): void
    {
        $this->purchaseDate = $purchaseDate;
    }

    public function getPlate(): ?string
    {
        return $this->plate;
    }

    public function setPlate(?string $plate): void
    {
        $this->plate = $plate;
    }

    public function getVIN(): ?string
    {
        return $this->VIN;
    }

    public function setVIN(?string $VIN): void
    {
        $this->VIN = $VIN;
    }
}
