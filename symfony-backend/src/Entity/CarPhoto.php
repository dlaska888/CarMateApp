<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity]
class CarPhoto extends File
{
    #[ORM\ManyToOne(targetEntity: Car::class, inversedBy: "photos")]
    #[ORM\JoinColumn(nullable: false)]
    private ?Car $car;
    
    public function getCar(): ?Car
    {
        return $this->car;
    }
    
    public function setCar(?Car $car): self
    {
        $this->car = $car;
        
        return $this;
    }
}