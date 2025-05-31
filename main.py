# PySide6-based GUI installer (Step 2: Main Menu UI with Column Buttons and Footer)

import sys
from PySide6.QtWidgets import (
    QApplication, QLabel, QWidget, QVBoxLayout, QPushButton, QHBoxLayout, QGridLayout, QToolButton, QCheckBox, QMessageBox, QDialog, QDialogButtonBox
)
from PySide6.QtGui import QDesktopServices
from PySide6.QtCore import Qt, QUrl

icon_links = [
    ("Main Site", "https://xerolinux.xyz/", ""),  # fa-globe
    ("GitHub", "https://github.com/XeroLinuxDev", ""),  # fa-brands fa-github
    ("Discord", "https://discord.gg/5sqxTSuKZu", ""),  # fa-brands fa-discord
    ("Fosstodon", "https://fosstodon.org/@XeroLinux", ""),  # fa-brands fa-mastodon
    ("YouTube", "https://youtube.com/@XeroLinux", "")  # fa-brands fa-youtube
]

class InstallerApp(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("XeroLinux Post-Install Toolkit")
        self.setGeometry(100, 100, 1000, 700)

        layout = QVBoxLayout()
        layout.setContentsMargins(30, 20, 30, 20)
        layout.setSpacing(2)

        header = QLabel("Welcome to XeroLinux !")
        header.setAlignment(Qt.AlignCenter)
        header.setStyleSheet("font-size: 36px; font-weight: bold; margin-bottom: 0px;")
        layout.addWidget(header)

        layout.addSpacing(50)  # Final adjusted spacing between header and support button

        support_btn = QPushButton("\ud83d\udcb2 Support Us \ud83d\udcb2")
        support_btn.setMinimumHeight(40)
        support_btn.setStyleSheet("background-color: #d9b3ff; border-radius: 18px; color: #333333; font-size: 20px; font-weight: bold;")
        support_btn.setCursor(Qt.PointingHandCursor)
        support_btn.setFixedWidth(200)
        support_btn.clicked.connect(self.show_support_popup)

        support_layout = QHBoxLayout()
        support_layout.addStretch()
        support_layout.addWidget(support_btn)
        support_layout.addStretch()
        layout.addLayout(support_layout)

        paragraph = QLabel("The XeroLinux Toolkit is your gateway to setting up, optimizing, and customizing your system effortlessly. It offers a series of guided steps for installing essential drivers, configuring system components, setting up development and gaming environments, and applying system tweaks. Whether you're a new user or a power user, this tool provides the essentials in a user-friendly form.")
        paragraph.setWordWrap(True)
        paragraph.setAlignment(Qt.AlignLeft)
        paragraph.setStyleSheet("margin-top: 20px; margin-bottom: 20px; font-size: 18px;")
        layout.addWidget(paragraph)

        grid_layout = QGridLayout()
        grid_layout.setVerticalSpacing(10)
        button_info = [
            ("System Setup", "Prepare your system with initial setup tasks"),
            ("System Drivers", "Install and configure hardware drivers"),
            ("Distrobox & Docker", "Set up container-based environments"),
            ("System Customization", "Tweak UI, themes, and behaviors"),
            ("Game Launchers/Tweaks", "Install gaming tools and performance tweaks"),
            ("Curated Package Installer", "Install a curated list of useful software")
        ]

        for i, (text, tooltip) in enumerate(button_info):
            btn = QPushButton(text)
            btn.setMinimumHeight(56)
            btn.setStyleSheet("font-size: 14px;")
            btn.setCursor(Qt.PointingHandCursor)
            btn.setToolTip(tooltip)
            grid_layout.addWidget(btn, i // 2, i % 2)

        layout.addLayout(grid_layout)
        layout.addSpacing(10)

        button7 = QPushButton("System Troubleshooting")
        button7.setToolTip("Apply known fixes and performance enhancements")
        button7.setMinimumHeight(56)
        button7.setFixedWidth(600)
        button7.setStyleSheet("font-weight: bold; font-size: 18px;")
        button7.setCursor(Qt.PointingHandCursor)
        container = QHBoxLayout()
        container.addStretch()
        container.addWidget(button7)
        container.addStretch()
        layout.addLayout(container)

        footer_container = QVBoxLayout()
        footer_container.setSpacing(8)

        footer_header = QLabel(".:: Find Us On ::.")
        footer_header.setAlignment(Qt.AlignCenter)
        footer_header.setStyleSheet("font-size: 16px; font-weight: bold; margin: 10px 0 4px 0;")
        footer_container.addWidget(footer_header)

        icon_layout = QHBoxLayout()
        icon_layout.setSpacing(8)
        icon_layout.setAlignment(Qt.AlignCenter)
        for name, link, icon in icon_links:
            btn = QToolButton()
            btn.setText(icon)
            btn.setToolTip(f"<span style='font-family:sans-serif; font-size:16px;'>{name}</span>")
            btn.setStyleSheet("font-family: 'Font Awesome 6 Free'; font-weight: 900; font-size: 24px; background-color: transparent; border: none;")
            btn.setCursor(Qt.PointingHandCursor)
            btn.clicked.connect(lambda checked, url=link: QDesktopServices.openUrl(QUrl(url)))
            icon_layout.addWidget(btn)

        footer_container.addLayout(icon_layout)

        toggle_layout = QHBoxLayout()
        toggle_layout.addStretch()

        self.startup_checkbox = QCheckBox("Launch on Startup")
        self.startup_checkbox.setToolTip("Toggle whether Xero Installer launches at system startup")
        toggle_layout.addWidget(self.startup_checkbox)

        layout.addLayout(footer_container)
        layout.addLayout(toggle_layout)

        self.setLayout(layout)

    def show_support_popup(self):
        dialog = QDialog(self)
        dialog.setWindowTitle("Support XeroLinux")
        dialog.setMinimumSize(600, 240)

        layout = QVBoxLayout()
        header = QLabel("\ud83d\udcb2 Project Support \ud83d\udcb2")
        header.setAlignment(Qt.AlignCenter)
        header.setStyleSheet("font-size: 24px; font-weight: bold; margin-bottom: 10px;")
        layout.addWidget(header)

        description = QLabel("Your support helps us keep the XeroLinux project alive and thriving. Whether it's covering hosting costs, developing new features, or providing user support, every contribution makes a difference. Thank you for considering to support us!")
        description.setWordWrap(True)
        description.setStyleSheet("font-size: 15px; margin-bottom: 15px;")
        layout.addWidget(description)

        grid = QGridLayout()
        support_links = [
            ("Ko-Fi", "https://ko-fi.com/XeroLinux"),
            ("FundRazr", "https://fundrazr.com/523mC5"),
            ("LiberaPay", "https://liberapay.com/DarkXero")
        ]

        grid.setSpacing(20)
        for i, (name, url) in enumerate(support_links):
            btn = QPushButton(name)
            if name == "Ko-Fi":
                btn.setFixedWidth(200)
            btn.setMinimumHeight(48)
            btn.setStyleSheet("font-size: 16px; font-weight: bold;")
            btn.setCursor(Qt.PointingHandCursor)
            btn.clicked.connect(lambda checked, link=url: QDesktopServices.openUrl(QUrl(link)))
            if name == "Ko-Fi":
                kofi_layout = QHBoxLayout()
                kofi_layout.addStretch()
                kofi_layout.addWidget(btn)
                kofi_layout.addStretch()
                layout.addLayout(kofi_layout)
            else:
                grid.addWidget(btn, 0, i - 1)
        layout.addLayout(grid)
        dialog.setLayout(layout)
        dialog.exec()

if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = InstallerApp()
    window.show()
    sys.exit(app.exec())
