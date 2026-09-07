import React, { useEffect } from 'react';
import { useForm } from '@inertiajs/react';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import { Modal } from '@/components/ui/Modal';

export interface CategoryRow {
    id: number;
    name: string;
    slug: string;
    parent_id: number | null;
    parent_name?: string | null;
    status: 'draft' | 'published' | 'archived';
    sort_order: number;
    products_count: number;
    children_count: number;
    created_at?: string | null;
}

export interface CategoryParentOption {
    id: number;
    name: string;
}

export interface CategoryFormValues {
    name: string;
    slug: string;
    parent_id: number | null;
    status: 'draft' | 'published' | 'archived';
    sort_order: number;
}

const STATUS_OPTIONS: { value: CategoryFormValues['status']; label: string }[] = [
    { value: 'draft', label: 'Draft' },
    { value: 'published', label: 'Published' },
    { value: 'archived', label: 'Archived' },
];

interface CategoryFormModalProps {
    open: boolean;
    onClose: () => void;
    category?: CategoryRow | null;
    parents: CategoryParentOption[];
}

export const CategoryFormModal: React.FC<CategoryFormModalProps> = ({
    open,
    onClose,
    category,
    parents,
}) => {
    const editing = !!category;

    const form = useForm<CategoryFormValues>({
        name: category?.name ?? '',
        slug: category?.slug ?? '',
        parent_id: category?.parent_id ?? null,
        status: category?.status ?? 'draft',
        sort_order: category?.sort_order ?? 0,
    });

    useEffect(() => {
        if (!open) return;
        form.setData({
            name: category?.name ?? '',
            slug: category?.slug ?? '',
            parent_id: category?.parent_id ?? null,
            status: category?.status ?? 'draft',
            sort_order: category?.sort_order ?? 0,
        });
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [open, category]);

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        const options = {
            preserveScroll: true,
            onSuccess: () => onClose(),
        };

        if (editing && category) {
            form.put(`/admin/categories/${category.id}`, options);
            return;
        }

        form.post('/admin/categories', options);
    };

    const parentOptions = (parents ?? []).filter((p) => p.id !== category?.id);

    return (
        <Modal
            isOpen={open}
            onClose={onClose}
            title={editing ? 'Edit Kategori' : 'Tambah Kategori'}
            size="md"
        >
            <form onSubmit={handleSubmit} className="space-y-5">
                <Input
                    label="Nama Kategori"
                    required
                    autoFocus
                    placeholder="cth: Gaming Mouse"
                    value={form.data.name}
                    onChange={(e) => form.setData('name', e.target.value)}
                    error={form.errors.name}
                />

                <Input
                    label="Slug"
                    placeholder="Kosongkan untuk dibuat otomatis dari nama"
                    hint="Digunakan di URL. Contoh: gaming-mouse"
                    value={form.data.slug}
                    onChange={(e) => form.setData('slug', e.target.value)}
                    error={form.errors.slug}
                />

                <div className="flex flex-col gap-1.5">
                    <label
                        htmlFor="category-parent"
                        className="text-xs font-semibold uppercase tracking-wider text-vgs-silver-mid"
                    >
                        Kategori Induk
                    </label>
                    <select
                        id="category-parent"
                        value={form.data.parent_id ?? ''}
                        onChange={(e) =>
                            form.setData('parent_id', e.target.value === '' ? null : Number(e.target.value))
                        }
                        className="w-full bg-vgs-black-surface text-vgs-silver-bright text-sm rounded-xl px-4 py-3 border border-vgs-gray-border focus:outline-none focus:border-vgs-blue-electric focus:ring-2 focus:ring-vgs-blue-electric/30 min-h-[44px]"
                    >
                        <option value="">Tanpa induk (kategori utama)</option>
                        {parentOptions.map((p) => (
                            <option key={p.id} value={p.id}>
                                {p.name}
                            </option>
                        ))}
                    </select>
                    {form.errors.parent_id && (
                        <p className="text-xs text-vgs-danger">{form.errors.parent_id}</p>
                    )}
                </div>

                <div className="grid grid-cols-2 gap-4">
                    <div className="flex flex-col gap-1.5">
                        <label
                            htmlFor="category-status"
                            className="text-xs font-semibold uppercase tracking-wider text-vgs-silver-mid"
                        >
                            Status
                        </label>
                        <select
                            id="category-status"
                            value={form.data.status}
                            onChange={(e) =>
                                form.setData('status', e.target.value as CategoryFormValues['status'])
                            }
                            className="w-full bg-vgs-black-surface text-vgs-silver-bright text-sm rounded-xl px-4 py-3 border border-vgs-gray-border focus:outline-none focus:border-vgs-blue-electric focus:ring-2 focus:ring-vgs-blue-electric/30 min-h-[44px]"
                        >
                            {STATUS_OPTIONS.map((opt) => (
                                <option key={opt.value} value={opt.value}>
                                    {opt.label}
                                </option>
                            ))}
                        </select>
                        {form.errors.status && (
                            <p className="text-xs text-vgs-danger">{form.errors.status}</p>
                        )}
                    </div>

                    <Input
                        label="Urutan"
                        type="number"
                        min={0}
                        value={form.data.sort_order === 0 ? '' : String(form.data.sort_order)}
                        onChange={(e) => form.setData('sort_order', Number(e.target.value))}
                        error={form.errors.sort_order}
                        hint="Semakin kecil tampil duluan"
                    />
                </div>

                <div className="flex items-center justify-end gap-3 pt-2">
                    <Button type="button" variant="ghost" onClick={onClose} disabled={form.processing}>
                        Batal
                    </Button>
                    <Button
                        type="submit"
                        variant="primary"
                        loading={form.processing}
                        disabled={form.processing || form.data.name.trim() === ''}
                    >
                        {editing ? 'Simpan Perubahan' : 'Tambah Kategori'}
                    </Button>
                </div>
            </form>
        </Modal>
    );
};

export default CategoryFormModal;