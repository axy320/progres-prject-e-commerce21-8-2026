<?php

namespace App\Domain\Catalog\Actions;

use App\Models\Category;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Str;

/**
 * Slug unik untuk kategori dengan fallback dari nama.
 */
trait ResolvesCategorySlug
{
    /**
     * @param  array<string, mixed>  $data
     */
    private function resolveSlug(array $data, ?Category $ignore = null): string
    {
        $base = isset($data['slug']) && trim((string) $data['slug']) !== ''
            ? (string) $data['slug']
            : Str::slug((string) $data['name']);

        $candidate = $base;
        $counter = 1;

        while ($this->slugExists($candidate, $ignore)) {
            $candidate = $base.'-'.$counter;
            $counter++;
        }

        return $candidate;
    }

    private function slugExists(string $slug, ?Category $ignore): bool
    {
        return Category::query()
            ->when($ignore, fn (Builder $q) => $q->whereKeyNot($ignore->id))
            ->where('slug', $slug)
            ->exists();
    }
}