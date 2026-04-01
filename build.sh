#!/bin/bash

# --- CONFIGURACIÓN DE RUTAS ---
ISO_DIR="ISO"
KERNEL_NAME="pavilionix86.bin"

echo "1. Compilando código fuente..."
nasm -f elf32 boot.asm -o boot.o
gcc -m32 -ffreestanding -fno-pic -fno-stack-protector -c kernel.c -o kernel.o

echo "2. Enlazando kernel con linker.ld..."
ld -m elf_i386 -T linker.ld boot.o kernel.o -o $KERNEL_NAME

echo "3. Actualizando imagen en $ISO_DIR..."
# Movemos el kernel recién compilado a la carpeta ISO
mv $KERNEL_NAME $ISO_DIR/

echo "4. Generando 1024OS.iso..."
xorriso -as mkisofs -o 1024OS.iso \
   -b isolinux.bin -c boot.cat \
   -no-emul-boot -boot-load-size 4 -boot-info-table \
   $ISO_DIR

echo "5. Limpiando archivos temporales..."
rm *.o

echo "¡Listo! 1024OS.iso ha sido generado exitosamente."
