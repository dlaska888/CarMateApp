<?php

namespace App\MappingProfiles;

use AutoMapperPlus\AutoMapperPlusBundle\AutoMapperConfiguratorInterface;
use AutoMapperPlus\Configuration\AutoMapperConfigInterface;

class AutoMapperConfig implements AutoMapperConfiguratorInterface
{
    public function configure(AutoMapperConfigInterface $config): void
    {
//        $config->registerMapping(UserRegisterDto::class, CarMateUser::class);
//
//        $config->registerMapping(Car::class, GetCarDto::class);
//        $config->registerMapping(CreateCarDto::class, Car::class);
//        $config->registerMapping(UpdateCarDto::class, Car::class);
    }
}