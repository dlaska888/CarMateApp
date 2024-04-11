<?php

namespace App\Dto\Maintenance;

use DateTimeInterface;
use Symfony\Component\Uid\Uuid;

class GetMaintenanceDto
{
    private ?Uuid $id;
    
    private ?string $name;

    private ?string $description;

    private ?int $dueMileage;

    private ?DateTimeInterface $dueDate;

    private ?string $cost;
    
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

    public function getDescription(): ?string
    {
        return $this->description;
    }

    public function setDescription(?string $description): void
    {
        $this->description = $description;
    }

    public function getDueMileage(): ?int
    {
        return $this->dueMileage;
    }

    public function setDueMileage(?int $dueMileage): void
    {
        $this->dueMileage = $dueMileage;
    }

    public function getDueDate(): ?DateTimeInterface
    {
        return $this->dueDate;
    }

    public function setDueDate(?DateTimeInterface $dueDate): void
    {
        $this->dueDate = $dueDate;
    }

    public function getCost(): ?string
    {
        return $this->cost;
    }

    public function setCost(?string $cost): void
    {
        $this->cost = $cost;
    }
    
}