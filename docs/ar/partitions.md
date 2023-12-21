# إدارة التقسيمات الأخري (Hard drives)
إدارة أو ربط التقسيمات الأخري هو أسهل من ذي قبل علي توزيعة NixOS, قم بربط القُرص الخاص بك في هذا المُجلد `mnt/{DRIVE_NAME}/` -- و قُم بتغيير الإسم بالإسم الذي اختارته.
بعدها قم بإجراء `nix-os-generate-config --root /mnt` سيصنع هذا ملف اسمه `hardware-configuration.nix` في المُجلد `mnt/`, قم بنسخ الإعدادات الخاصة بالأقراص الخاصة بك و قم بوضعها في ملفك الأساسي `hardware-configuration.nix`.
شاهد هذا الإقتراف للتوضيح [فرق الإقتراف](https://github.com/Al-Ghoul/NixOS-Conf/commit/f9fe269005b0ce064a0af60ad715310c485a9667#diff-a8a5dc4d98dca155b4d66f435f89f3f8046c400979b5f2e6a8a6475d7e74c205)

علي سبيل المثال: إجراء `lsblk` علي جهازي الخاص يقوم بإخراج الآتي:
```bash
# توزيعات و أقراص أخري
sdb1    8:17   0 232.9G  0 part 
└─sdb   8:16   0 232.9G  0 disk 
# توزيعات و أقراص أخري
```
سأُركز علي هذا القُرص `sdb1` و هو قرص بحجم 232 جيجا بايت, و سأقوم بربطه بهذا المسار `mnt/HardDriveTwo/` بالإجراء الآتي
```bash
sudo mount /dev/sdb1 /mnt/HardDriveTwo
```
سينتج عنه هذا الخطأ (إن لم يواجهك هذا الخطأ, قم بتخطي هذه الخطوة [إضافة الإعدادات الجديدة](#توليد-و-إضافة-الإعدادات-الجديدة)
```bash
mount: /mnt/HardDriveTwo: unknown filesystem type 'ntfs'.
       dmesg(1) may have more information after failed mount system call.
```
و هذا لأن صيغة هذا القرص هي NTFS (صيغة مستخدمة من قبل توزيعة Windows), علينا أن نمرر نوع القرص بشكلٍ صريح
```bash
sudo mount /dev/sdb1 /mnt/HardDriveTwo -t ntfs3
```
و يجب علي هذا أن يقوم بربط القُرص في المسار `mnt/HardDriveTwo/`.

## توليد و إضافة الإعدادات الجديدة
يمكنك الآن أن تقوم بإجراء `nix-os-generate-config --root /mnt` و هذا سينتج عنه ملف `hardware-configuration.nix` في المسار `mnt/`,
قم بنسخ الإعدادات الجديدة ببساطة و التي تُمثل الأقراص الجديدة و قُم بإضافتهم لإعداداتك الأصلية في `hardware-configuration.nix` و قم بمسح الآخر الجديد و الذي يوجد بـ`mnt/`.
