<?php

namespace App\MappingProfiles;

use App\Dto\Car\CreateCarDto;
use App\Dto\Car\GetCarDto;
use App\Dto\Maintenance\GetMaintenanceDto;
use App\Entity\Car;
use AutoMapperPlus\AutoMapperInterface;
use AutoMapperPlus\AutoMapperPlusBundle\AutoMapperConfiguratorInterface;
use AutoMapperPlus\Configuration\AutoMapperConfigInterface;

class AutoMapperConfig implements AutoMapperConfiguratorInterface
{
    public function configure(AutoMapperConfigInterface $config): void
    {
//        $config->registerMapping(UserRegisterDto::class, User::class);
//
//        $config->registerMapping(Car::class, GetCarDto::class);
//        $config->registerMapping(CreateCarDto::class, Car::class);
//        $config->registerMapping(UpdateCarDto::class, Car::class);

        $config->registerMapping(Car::class, GetCarDto::class)
            ->dontSkipConstructor()
            ->forMember('maintenances', function (Car $car, AutoMapperInterface $autoMapper) {
                    return $autoMapper->mapMultiple($car->getMaintenances(), GetMaintenanceDto::class);
            });
    }
}