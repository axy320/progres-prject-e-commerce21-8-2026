import React, { useEffect, useMemo, useRef, useState } from 'react';
import { useForm, usePage } from '@inertiajs/react';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import { Chip } from '@/components/ui/Chip';

export interface BrandOption {
    id: number | string;
    name: string;
}

export interface CategoryOption {
    id: number | string;
    name: string;
    parent_id?: number | string | null;
}

export interface ExistingImage {
    id: number | string;
    url: string | null;
    sort_order?: number;
    is_primary?: boolean;
}

export interface ExistingVariant {
    id?: number | string;
    sku: string;
    price: number;
    compare_at_price?: number | null;
}

export interface ProductInitialData {
    id?: number | string;
    name: string;
    slug?: string | null;
    brand_id?: number | string | null;
    category_ids?: (number | string)[];
    description?: string | null;
    status?: string;
    images?: ExistingImage[];
    variants?: ExistingVariant[];
}

interface ProductFormProps {
    mode: 'create' | 'edit';
    categories: CategoryOption[];
    brands: BrandOption[];
    initialProduct?: ProductInitialData;
}

type GalleryItem =
    | { kind: 'existing'; id: number | string; url: string | null }
    | { kind: 'new'; file: File; previewUrl: string };

interface VariantRow {
    key: number;
    id?: number | string;
    sku: string;
    price: string;
    compareAtPrice: string;
}

const STATUS_OPTIONS = [
    { value: 'draft', label: 'Draft' },
    { value: 'published', label: 'Published' },
];

export default function ProductForm({ mode, categories, brands, initialProduct }: ProductFormProps) {
    const isEdit = mode === 'edit';

    const { errors: page } = usePage().props as { errors?: Record<string, unknown> };
    const pageErrors = page ?? {};

    const form = useForm<{
        _method?: string;
        name: string;
        slug: string;
        brand_id: number | string | null;
        category_ids: (number | string)[];
        description: string;
        status: string;
        images: File[];
        primary_index: number;
        kept_images: { id: number | string; sort_order: number }[];
        new_images: File[];
        delete_image_ids: (number | string)[];
        primary_ref: string;
        variants: { id?: number | string; sku: string; price: string; compare_at_price: string }[];
        delete_variant_ids: (number | string)[];
    }>({
        _method: isEdit ? 'PUT' : undefined,
        name: initialProduct?.name ?? '',
        slug: initialProduct?.slug ?? '',
        brand_id: initialProduct?.brand_id ?? null,
        category_ids: initialProduct?.category_ids ?? [],
        description: initialProduct?.description ?? '',
        status: initialProduct?.status ?? 'draft',
        images: [],
        primary_index: 0,
        kept_images: [],
        new_images: [],
        delete_image_ids: [],
        primary_ref: '',
        variants: [],
        delete_variant_ids: [],
    });

    // --- Kategori ---
    const toggleCategory = (id: number | string) => {
        const exists = form.data.category_ids.includes(id);
        const next = exists ? form.data.category_ids.filter((c) => c !== id) : [...form.data.category_ids, id];
        form.setData('category_ids', next);
    };

    // --- Galeri gambar ---
    const [gallery, setGallery] = useState<GalleryItem[]>([]);
    const [primaryIndex, setPrimaryIndex] = useState(0);
    const [removedImageIds, setRemovedImageIds] = useState<(number | string)[]>([]);
    const fileInputRef = useRef<HTMLInputElement>(null);
    const objectUrlsRef = useRef<string[]>([]);

    useEffect(() => {
        if (isEdit && initialProduct?.images?.length) {
            const items: GalleryItem[] = initialProduct.images.map((img) => ({
                kind: 'existing',
                id: img.id,
                url: img.url,
            }));
            setGallery(items);
            const primaryIdx = initialProduct.images.findIndex((i) => i.is_primary);
            setPrimaryIndex(primaryIdx >= 0 ? primaryIdx : 0);
        }
    }, [isEdit, initialProduct]);

    useEffect(() => {
        return () => {
            objectUrlsRef.current.forEach((url) => URL.revokeObjectURL(url));
        };
    }, []);

    // Kelola revoke URL saat galeri baru dihapus/diganti
    useEffect(() => {
        const prevUrls = new Set(objectUrlsRef.current);
        const currentUrls = new Set(
            gallery.filter((g) => g.kind === 'new').map((g) => (g as any).previewUrl),
        );
        prevUrls.forEach((url) => {
            if (!currentUrls.has(url)) URL.revokeObjectURL(url);
        });
        objectUrlsRef.current = Array.from(currentUrls);
    }, [gallery]);

    const handleFilesSelected = (files: FileList | null) => {
        if (!files) return;
        const valid = Array.from(files).filter((f) => f.type.startsWith('image/'));
        const newItems: GalleryItem[] = valid.map((file) => ({
            kind: 'new',
            file,
            previewUrl: URL.createObjectURL(file),
        }));
        setGallery((prev) => [...prev, ...newItems]);
        if (fileInputRef.current) fileInputRef.current.value = '';
    };

    const removeImage = (index: number) => {
        const target = gallery[index];
        if (target?.kind === 'existing') {
            setRemovedImageIds((prev) => [...prev, target.id]);
        }
        setGallery((prev) => prev.filter((_, i) => i !== index));
        setPrimaryIndex((p) => {
            if (index === p) return 0;
            if (p > index) return p - 1;
            return p;
        });
    };

    // Urutkan ulang (tombol naik/turun sederhana)
    const moveImage = (index: number, dir: -1 | 1) => {
        const target = index + dir;
        if (target < 0 || target >= gallery.length) return;
        setGallery((prev) => {
            const next = [...prev];
            [next[index], next[target]] = [next[target], next[index]];
            return next;
        });
        setPrimaryIndex((p) => {
            if (p === index) return target;
            if (p === target) return index;
            return p;
        });
    };

    // --- Varian ---
    const [variants, setVariants] = useState<VariantRow[]>(() => {
        if (isEdit && initialProduct?.variants?.length) {
            return initialProduct.variants.map((v, i) => ({
                key: i,
                id: v.id,
                sku: v.sku,
                price: String(v.price ?? ''),
                compareAtPrice: v.compare_at_price != null ? String(v.compare_at_price) : '',
            }));
        }
        return [{ key: 0, sku: '', price: '', compareAtPrice: '' }];
    });
    const variantKeyCounter = useRef(variants.length);
    const [removedVariantIds, setRemovedVariantIds] = useState<(number | string)[]>([]);

    const addVariantRow = () => {
        const key = variantKeyCounter.current++;
        setVariants((prev) => [...prev, { key, sku: '', price: '', compareAtPrice: '' }]);
    };

    const removeVariantRow = (rowKey: number) => {
        if (variants.length <= 1) return;
        const target = variants.find((v) => v.key === rowKey);
        if (target?.id != null) {
            setRemovedVariantIds((prev) => [...prev, target.id as number | string]);
        }
        setVariants((prev) => prev.filter((v) => v.key !== rowKey));
    };

    const updateVariant = (rowKey: number, field: keyof VariantRow, value: string) => {
        setVariants((prev) => prev.map((v) => (v.key === rowKey ? { ...v, [field]: value } : v)));
    };

    // Cek SKU duplikat antar baris (frontend)
    const duplicateSkus = useMemo(() => {
        const seen = new Map<string, number>();
        variants.forEach((v) => {
            const sku = v.sku.trim().toLowerCase();
            if (!sku) return;
            if (seen.has(sku)) {
                seen.set(sku, seen.get(sku)! + 1);
            } else {
                seen.set(sku, 0);
            }
        });
        const dup = new Set<string>();
        seen.forEach((count, sku) => {
            if (count > 0) dup.add(sku);
        });
        return dup;
    }, [variants]);

    // --- Submit ---
    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();

        if (gallery.length === 0) {
            form.setError('images', 'Minimal satu gambar produk wajib dipilih.');
            return;
        }

        // Persiapkan data gambar sesuai mode
        if (isEdit) {
            const kept: { id: number | string; sort_order: number }[] = [];
            const newFiles: File[] = [];
            let primaryRef = '';

            gallery.forEach((item, index) => {
                if (item.kind === 'existing') {
                    kept.push({ id: item.id, sort_order: index });
                    if (index === primaryIndex) primaryRef = `existing:${item.id}`;
                } else {
                    const newIdx = newFiles.length;
                    newFiles.push(item.file);
                    if (index === primaryIndex) primaryRef = `new:${newIdx}`;
                }
            });

            form.setData({
                ...form.data,
                kept_images: kept,
                new_images: newFiles,
                delete_image_ids: removedImageIds,
                primary_ref: primaryRef,
                variants: variants.map((v) => ({
                    id: v.id ?? undefined,
                    sku: v.sku.trim(),
                    price: v.price,
                    compare_at_price: v.compareAtPrice,
                })),
                delete_variant_ids: removedVariantIds,
            });

            form.post(`/admin/products/${initialProduct?.id}`, {
                forceFormData: true,
                onError: () => form.clearErrors('images'),
            });
            return;
        }

        form.setData((prev) => ({
            ...prev,
            primary_index: primaryIndex,
            images: gallery
                .filter((g) => g.kind === 'new')
                .map((g) => (g as { kind: 'new'; file: File }).file),
            variants: variants.map((v) => ({
                id: undefined,
                sku: v.sku.trim(),
                price: v.price,
                compare_at_price: v.compareAtPrice,
            })),
        }));

        form.post('/admin/products', {
            forceFormData: true,
            onError: () => form.clearErrors('images'),
        });
    };

    const getError = (key: string) => {
        const err = (form.errors as Record<string, string>)[key];
        if (err) return err;
        return getPageError(key);
    };

    const getPageError = (key: string) => {
        const err = pageErrors[key];
        if (typeof err === 'string' && err) return err;
        if (Array.isArray(err)) return err[0] as string | undefined;
        return undefined;
    };

    const getVariantError = (index: number, field: 'sku' | 'price') => {
        return getError(`variants.${index}.${field}`);
    };

    const tokenTail = mode === 'create' ? 'Simpan Produk' : 'Simpan Perubahan';

    // Kumpulan error backend yang belum ditampilkan inline, supaya tiap kegagalan
    // validasi tetap terlihat jelas (tidak "diam tanpa feedback").
    const formErrors = [
        ...Object.values(form.errors as Partial<Record<string, string>>),
        ...Object.values(pageErrors).map((v) => (typeof v === 'string' ? v : Array.isArray(v) ? v[0] : null)),
    ].filter((m): m is string => Boolean(m));

    return (
        <form onSubmit={handleSubmit} noValidate>
            {formErrors.length > 0 && (
                <div className="mb-6 rounded-xl border border-vgs-danger/40 bg-vgs-danger/10 px-4 py-3">
                    <p className="text-sm font-semibold text-vgs-danger">
                        Produk tidak dapat disimpan. Perbaiki isian berikut lalu coba lagi:
                    </p>
                    <ul className="mt-1 list-disc list-inside text-xs text-vgs-danger">
                        {formErrors.map((msg, i) => (
                            <li key={`${i}-${msg}`}>{msg}</li>
                        ))}
                    </ul>
                </div>
            )}

            {/* Informasi Dasar */}
            <section className="rounded-2xl bg-vgs-black-surface border border-vgs-gray-border overflow-hidden">
                <div className="px-6 py-4 border-b border-vgs-gray-border">
                    <h3 className="font-display font-bold text-vgs-silver-bright">Informasi Dasar</h3>
                </div>
                <div className="p-6 flex flex-col gap-5">
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
                        <Input
                            label="Nama Produk"
                            required
                            value={form.data.name}
                            onChange={(e) => form.setData('name', e.target.value)}
                            placeholder="Mis. VGS Mechanical Keyboard Pro"
                            error={getError('name')}
                        />
                        <Input
                            label="Slug (opsional)"
                            value={form.data.slug}
                            onChange={(e) => form.setData('slug', e.target.value)}
                            placeholder="dibiarkan kosong untuk otomatis dari nama"
                            hint="Otomatis dibuat dari nama jika dikosongkan."
                        />
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
                        <div className="flex flex-col gap-1.5">
                            <label className="text-xs font-semibold uppercase tracking-wider text-vgs-silver-mid" htmlFor="brand_id">
                                Brand
                            </label>
                            <select
                                id="brand_id"
                                value={form.data.brand_id ?? ''}
                                onChange={(e) => form.setData('brand_id', e.target.value ? Number(e.target.value) : null)}
                                className="w-full bg-vgs-black-surface text-vgs-silver-bright text-sm rounded-xl px-4 py-3 border border-vgs-gray-border focus:outline-none focus:border-vgs-blue-electric focus:ring-2 focus:ring-vgs-blue-electric/30 min-h-[44px]"
                            >
                                <option value="">Pilih brand…</option>
                                {brands.map((b) => (
                                    <option key={b.id} value={b.id}>
                                        {b.name}
                                    </option>
                                ))}
                            </select>
                        </div>
                        <div className="flex flex-col gap-1.5">
                            <label className="text-xs font-semibold uppercase tracking-wider text-vgs-silver-mid" htmlFor="status">
                                Status
                            </label>
                            <select
                                id="status"
                                value={form.data.status}
                                onChange={(e) => form.setData('status', e.target.value)}
                                className="w-full bg-vgs-black-surface text-vgs-silver-bright text-sm rounded-xl px-4 py-3 border border-vgs-gray-border focus:outline-none focus:border-vgs-blue-electric focus:ring-2 focus:ring-vgs-blue-electric/30 min-h-[44px]"
                            >
                                {STATUS_OPTIONS.map((s) => (
                                    <option key={s.value} value={s.value}>
                                        {s.label}
                                    </option>
                                ))}
                            </select>
                        </div>
                    </div>

                    <div className="flex flex-col gap-1.5">
                        <label className="text-xs font-semibold uppercase tracking-wider text-vgs-silver-mid">
                            Kategori <span className="text-vgs-danger">*</span>
                            <span className="ml-2 normal-case font-normal text-vgs-silver-muted">
                                Pilih minimal satu
                            </span>
                        </label>
                        <div className="flex flex-wrap gap-2">
                            {categories.map((c) => {
                                const selected = form.data.category_ids.includes(c.id);
                                return (
                                    <Chip
                                        key={c.id}
                                        label={c.name}
                                        selected={selected}
                                        showCheck
                                        onClick={() => toggleCategory(c.id)}
                                    >
                                        {c.name}
                                    </Chip>
                                );
                            })}
                        </div>
                        {getError('category_ids') && (
                            <p className="text-xs text-vgs-danger mt-1">{getError('category_ids')}</p>
                        )}
                    </div>

                    <div className="flex flex-col gap-1.5">
                        <label className="text-xs font-semibold uppercase tracking-wider text-vgs-silver-mid" htmlFor="description">
                            Deskripsi
                        </label>
                        <textarea
                            id="description"
                            value={form.data.description}
                            onChange={(e) => form.setData('description', e.target.value)}
                            rows={5}
                            placeholder="Deskripsi lengkap produk…"
                            className="w-full bg-vgs-black-surface text-vgs-silver-bright placeholder:text-vgs-silver-muted text-sm rounded-xl px-4 py-3 border border-vgs-gray-border focus:outline-none focus:border-vgs-blue-electric focus:ring-2 focus:ring-vgs-blue-electric/30 min-h-[100px]"
                        />
                        {getError('description') && <p className="text-xs text-vgs-danger">{getError('description')}</p>}
                    </div>
                </div>
            </section>

            {/* Galeri Gambar */}
            <section className="rounded-2xl bg-vgs-black-surface border border-vgs-gray-border overflow-hidden mt-6">
                <div className="px-6 py-4 border-b border-vgs-gray-border flex items-center justify-between">
                    <h3 className="font-display font-bold text-vgs-silver-bright">Galeri Gambar</h3>
                    <span className="text-xs text-vgs-silver-muted">Minimal 1 gambar · pilih "Utama" untuk cover</span>
                </div>
                <div className="p-6 flex flex-col gap-4">
                    <input
                        ref={fileInputRef}
                        type="file"
                        accept="image/jpeg,image/png,image/webp"
                        multiple
                        className="hidden"
                        onChange={(e) => handleFilesSelected(e.target.files)}
                    />
                    <button
                        type="button"
                        onClick={() => fileInputRef.current?.click()}
                        className="inline-flex items-center justify-center gap-2 px-5 py-3 text-sm font-semibold text-vgs-blue-electric border border-dashed border-vgs-blue-electric/40 bg-vgs-blue-electric/5 hover:bg-vgs-blue-electric/10 hover:border-vgs-blue-electric rounded-xl transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-vgs-blue-electric cursor-pointer"
                    >
                        <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                        </svg>
                        Tambah Gambar
                    </button>

                    {getError('images') && (
                        <p className="text-xs text-vgs-danger">{getError('images')}</p>
                    )}

                    {gallery.length > 0 && (
                        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4">
                            {gallery.map((item, index) => (
                                <div
                                    key={item.kind === 'existing' ? `e-${item.id}` : `n-${(item as any).previewUrl}`}
                                    className={`relative rounded-xl overflow-hidden border aspect-square bg-vgs-black-void ${
                                        index === primaryIndex
                                            ? 'border-vgs-blue-electric ring-2 ring-vgs-blue-electric/40'
                                            : 'border-vgs-gray-border'
                                    }`}
                                >
                                    <img
                                        src={item.kind === 'existing' ? (item.url ?? '') : (item as any).previewUrl}
                                        alt={`Gambar produk ${index + 1}`}
                                        className="w-full h-full object-cover"
                                    />
                                    <div className="absolute top-2 left-2 flex gap-1">
                                        <button
                                            type="button"
                                            onClick={() => moveImage(index, -1)}
                                            disabled={index === 0}
                                            aria-label={`Pindah gambar ke-${index + 1} ke atas`}
                                            className="w-8 h-8 rounded-md bg-vgs-black-elevated/90 border border-vgs-gray-border text-vgs-silver-bright hover:border-vgs-blue-electric disabled:opacity-40 flex items-center justify-center transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-vgs-blue-electric"
                                        >
                                            ↑
                                        </button>
                                        <button
                                            type="button"
                                            onClick={() => moveImage(index, 1)}
                                            disabled={index === gallery.length - 1}
                                            aria-label={`Pindah gambar ke-${index + 1} ke bawah`}
                                            className="w-8 h-8 rounded-md bg-vgs-black-elevated/90 border border-vgs-gray-border text-vgs-silver-bright hover:border-vgs-blue-electric disabled:opacity-40 flex items-center justify-center transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-vgs-blue-electric"
                                        >
                                            ↓
                                        </button>
                                    </div>

                                    <button
                                        type="button"
                                        onClick={() => removeImage(index)}
                                        aria-label={`Hapus gambar ke-${index + 1}`}
                                        className="absolute top-2 right-2 w-8 h-8 rounded-md bg-vgs-black-elevated/90 border border-vgs-gray-border text-vgs-danger hover:bg-vgs-danger hover:text-white flex items-center justify-center transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-vgs-danger cursor-pointer"
                                    >
                                        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                        </svg>
                                    </button>

                                    <label className="absolute bottom-2 left-2 flex items-center gap-1.5 px-2 py-1 rounded-md bg-vgs-black-elevated/90 border border-vgs-gray-border text-xs text-vgs-silver-mid cursor-pointer focus-within:ring-2 focus-within:ring-vgs-blue-electric">
                                        <input
                                            type="radio"
                                            name="primary_image"
                                            checked={index === primaryIndex}
                                            onChange={() => setPrimaryIndex(index)}
                                            className="accent-vgs-blue-electric"
                                        />
                                        Utama
                                    </label>
                                </div>
                            ))}
                        </div>
                    )}

                    {gallery.length === 0 && (
                        <p className="text-xs text-vgs-silver-muted">
                            Belum ada gambar. Tambahkan minimal satu gambar untuk produk.
                        </p>
                    )}
                </div>
            </section>

            {/* Varian */}
            <section className="rounded-2xl bg-vgs-black-surface border border-vgs-gray-border overflow-hidden mt-6">
                <div className="px-6 py-4 border-b border-vgs-gray-border flex items-center justify-between">
                    <h3 className="font-display font-bold text-vgs-silver-bright">Varian Produk</h3>
                    <span className="text-xs text-vgs-silver-muted">Minimal 1 varian wajib ada</span>
                </div>
                <div className="p-6 flex flex-col gap-4">
                    {getError('variants') && (
                        <p className="text-xs text-vgs-danger">{getError('variants')}</p>
                    )}

                    <div className="hidden sm:grid grid-cols-12 gap-3 text-[10px] font-mono uppercase tracking-widest text-vgs-silver-muted">
                        <div className="col-span-4">SKU *</div>
                        <div className="col-span-3">Harga *</div>
                        <div className="col-span-3">Harga Coret (Opsional)</div>
                        <div className="col-span-2 text-right">Hapus</div>
                    </div>

                    {variants.map((variant) => {
                        const skuLower = variant.sku.trim().toLowerCase();
                        const isDup = Boolean(skuLower && duplicateSkus.has(skuLower));
                        const skuError = getVariantError(
                            variants.findIndex((v) => v.key === variant.key),
                            'sku',
                        );
                        return (
                            <div key={variant.key} className="grid grid-cols-1 sm:grid-cols-12 gap-3 items-start">
                                <div className="col-span-6 sm:col-span-4">
                                    <Input
                                        label="SKU"
                                        required
                                        placeholder="Mis. VGS-KB-PRO-BLK"
                                        value={variant.sku}
                                        onChange={(e) => updateVariant(variant.key, 'sku', e.target.value)}
                                        error={skuError || (isDup ? 'SKU duplikat dalam form ini.' : undefined)}
                                    />
                                </div>
                                <div className="col-span-6 sm:col-span-3">
                                    <Input
                                        label="Harga"
                                        required
                                        type="number"
                                        min={0}
                                        placeholder="150000"
                                        value={variant.price}
                                        onChange={(e) => updateVariant(variant.key, 'price', e.target.value)}
                                        error={getVariantError(
                                            variants.findIndex((v) => v.key === variant.key),
                                            'price',
                                        )}
                                    />
                                </div>
                                <div className="col-span-6 sm:col-span-3">
                                    <Input
                                        label="Harga Coret"
                                        type="number"
                                        min={0}
                                        placeholder="200000"
                                        value={variant.compareAtPrice}
                                        onChange={(e) => updateVariant(variant.key, 'compareAtPrice', e.target.value)}
                                    />
                                </div>
                                <div className="col-span-6 sm:col-span-2 flex sm:justify-end items-end">
                                    <Button
                                        type="button"
                                        variant="ghost"
                                        size="icon"
                                        aria-label={`Hapus varian ${variant.sku || 'tanpa SKU'}`}
                                        disabled={variants.length <= 1}
                                        onClick={() => removeVariantRow(variant.key)}
                                    >
                                        <svg className="w-4 h-4 text-vgs-danger" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5-4h4a1 1 0 011 1v3H9V4a1 1 0 011-1z" />
                                        </svg>
                                    </Button>
                                </div>
                            </div>
                        );
                    })}

                    <div>
                        <Button type="button" variant="outline" size="sm" onClick={addVariantRow}>
                            + Tambah Varian
                        </Button>
                    </div>
                </div>
            </section>

            {/* Submit */}
            <div className="mt-6 flex flex-col sm:flex-row items-stretch sm:items-center justify-end gap-3">
                <Button
                    type="button"
                    variant="ghost"
                    href={`/admin/products${isEdit ? `/${initialProduct?.id}/edit` : '/create'}`}
                >
                    Batalkan
                </Button>
                <Button type="submit" variant="primary" loading={form.processing}>
                    {form.processing ? 'Menyimpan…' : tokenTail}
                </Button>
            </div>
        </form>
    );
}
