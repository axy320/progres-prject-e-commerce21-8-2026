<?php

namespace App\Domain\Catalog\Actions;

use App\Models\Category;

final class DeleteCategoryAction
{
    public function execute(Category $category): void
    {
        $category->delete();
    }
}