<?php

namespace App\Entity;

use App\Repository\CarRepository;
use DateTimeInterface;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Bridge\Doctrine\Types\UuidType;
use Symfony\Component\Uid\Uuid;

#[ORM\Entity(repositoryClass: CarRepository::class)]
class Car
{
    #[ORM\Id]
    #[ORM\Column(type: UuidType::NAME, unique: true)]
    #[ORM\GeneratedValue(strategy: 'CUSTOM')]
    #[ORM\CustomIdGenerator(class: 'doctrine.uuid_generator')]
    private ?Uuid $id = null;

    #[ORM\Column(type: "string", length: 50)]
    private ?string $name = null;

    #[ORM\Column(type: "string", length: 255, nullable: true)]
    private ?string $model = null;

    #[ORM\Column(type: "string", length: 255, nullable: true)]
    private ?string $brand = null;

    #[ORM\Column(type: "float", nullable: true)]
    private ?float $displacement = null;

    #[ORM\Column(type: "datetime", nullable: true)]
    private ?DateTimeInterface $productionDate = null;

    #[ORM\Column(type: "integer", nullable: true)]
    private ?int $mileage = null;

    #[ORM\Column(type: "datetime", nullable: true)]
    private ?DateTimeInterface $purchaseDate = null;

    #[ORM\Column(type: "string", length: 255, nullable: true)]
    private ?string $plate = null;

    #[ORM\Column(type: "string", length: 255, nullable: true)]
    private ?string $vin = null;

    #[ORM\ManyToOne(targetEntity: CarMateUser::class, inversedBy: "cars")]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    private ?CarMateUser $user;
    
    #[ORM\OneToOne(targetEntity: CarPhoto::class)]
    #[ORM\JoinColumn(nullable: true)]
    private ?CarPhoto $currentPhoto = null;

    #[ORM\OneToMany(targetEntity: Maintenance::class, mappedBy: "car")]
    private Collection $maintenances;

    #[ORM\OneToMany(targetEntity: CarPhoto::class, mappedBy: "car")]
    private Collection $photos;
    
    public function __construct()
    {
        $this->maintenances = new ArrayCollection();
        $this->photos = new ArrayCollection();
    }

    public function getId(): ?Uuid
    {
        return $this->id;
    }

    public function getName(): ?string
    {
        return $this->name;
    }

    public function setName(string $name): self
    {
        $this->name = $name;

        return $this;
    }

    public function getModel(): ?string
    {
        return $this->model;
    }

    public function setModel(string $model): self
    {
        $this->model = $model;
        return $this;
    }

    public function getBrand(): ?string
    {
        return $this->brand;
    }

    public function setBrand(string $brand): self
    {
        $this->brand = $brand;
        return $this;
    }

    public function getDisplacement(): ?int
    {
        return $this->displacement;
    }

    public function setDisplacement(int $displacement): self
    {
        $this->displacement = $displacement;
        return $this;
    }

    public function getProductionDate(): ?DateTimeInterface
    {
        return $this->productionDate;
    }

    public function setProductionDate(DateTimeInterface $productionDate): self
    {
        $this->productionDate = $productionDate;
        return $this;
    }

    public function getMileage(): ?int
    {
        return $this->mileage;
    }

    public function setMileage(int $mileage): self
    {
        $this->mileage = $mileage;
        return $this;
    }

    public function getPurchaseDate(): ?DateTimeInterface
    {
        return $this->purchaseDate;
    }

    public function setPurchaseDate(DateTimeInterface $purchaseDate): self
    {
        $this->purchaseDate = $purchaseDate;
        return $this;
    }

    public function getPlate(): ?string
    {
        return $this->plate;
    }

    public function setPlate(string $plate): self
    {
        $this->plate = $plate;
        return $this;
    }

    public function getVin(): ?string
    {
        return $this->vin;
    }

    public function setVin(string $vin): self
    {
        $this->vin = $vin;
        return $this;
    }

    public function getUser(): ?CarMateUser
    {
        return $this->user;
    }

    public function setUser(?CarMateUser $user): self
    {
        $this->user = $user;
        return $this;
    }
    
    public function getCurrentPhoto(): ?CarPhoto
    {
        return $this->currentPhoto;
    }
    
    public function setCurrentPhoto(?CarPhoto $currentPhoto): self
    {
        $this->currentPhoto = $currentPhoto;
        return $this;
    }

    public function getMaintenances(): Collection
    {
        return $this->maintenances;
    }

    public function addMaintenance(Maintenance $maintenance): self
    {
        if (!$this->maintenances->contains($maintenance)) {
            $this->maintenances[] = $maintenance;
            $maintenance->setCar($this);
        }

        return $this;
    }

    public function removeMaintenance(Maintenance $maintenance): self
    {
        if ($this->maintenances->removeElement($maintenance)) {
            if ($maintenance->getCar() === $this) {
                $maintenance->setCar(null);
            }
        }

        return $this;
    }

    public function getPhotos(): Collection
    {
        return $this->photos;
    }

    public function addPhoto(CarPhoto $photo): self
    {
        if (!$this->photos->contains($photo)) {
            $this->photos[] = $photo;
        }
        
        return $this;
    }

    public function removePhoto(CarPhoto $photo): self
    {
        $this->photos->removeElement($photo);
        return $this;
    }

}
