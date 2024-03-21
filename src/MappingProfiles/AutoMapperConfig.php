<?php

namespace App\MappingProfiles;

use App\Dto\UserRegisterDto;
use App\Entity\CarMateUser;
use AutoMapperPlus\AutoMapperPlusBundle\AutoMapperConfiguratorInterface;
use AutoMapperPlus\Configuration\AutoMapperConfigInterface;

class AutoMapperConfig implements AutoMapperConfiguratorInterface
{
    public function configure(AutoMapperConfigInterface $config): void
    {
        $config->registerMapping(UserRegisterDto::class, CarMateUser::class);
    }
}