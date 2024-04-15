<?php

namespace App\Dto;

class PagedResultsDto
{
    public array $data;
    public int $totalPages;
    public int $currentPage;
    public int $perPage;
    public int $totalItems;

    public function __construct(array $data, int $totalItems, int $currentPage, int $perPage)
    {
        $this->data = $data;
        $this->totalItems = $totalItems;
        $this->currentPage = $currentPage;
        $this->perPage = $perPage;
        $this->totalPages = ceil($totalItems / $perPage);
    }

    public function getData(): array
    {
        return $this->data;
    }

    public function getTotalPages(): int
    {
        return $this->totalPages;
    }

    public function getCurrentPage(): int
    {
        return $this->currentPage;
    }

    public function getPerPage(): int
    {
        return $this->perPage;
    }

    public function getTotalItems(): int
    {
        return $this->totalItems;
    }
}
