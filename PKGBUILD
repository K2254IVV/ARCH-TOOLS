pkgname=archtools
pkgver=1.0
pkgrel=1
pkgdesc="K2254's Arch Linux setup tools"
arch=('any')
url="https://github.com/K2254IVV/ARCH-TOOLS"
license=('MIT')
depends=('curl' 'bash')
source=()
md5sums=()

package() {
    # Создаем директорию для пакета
    install -d "$pkgdir/usr/bin"
    
    # Создаем скрипт-обертку который запустит твой установщик
    cat > "$pkgdir/usr/bin/archtools-install" << EOF
#!/bin/bash
sh -c "\$(curl -fsSL https://raw.githubusercontent.com/K2254IVV/ARCH-TOOLS/main/files/ArchTools/install.sh)"
EOF

    chmod +x "$pkgdir/usr/bin/archtools-install"
    
    # Добавляем хук для запуска при установке
    install -d "$pkgdir/usr/share/libalpm/scripts"
    cat > "$pkgdir/usr/share/libalpm/scripts/archtools-setup" << EOF
#!/bin/bash
/usr/bin/archtools-install
EOF

    chmod +x "$pkgdir/usr/share/libalpm/scripts/archtools-setup"
}
