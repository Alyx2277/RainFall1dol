cmake_minimum_required(VERSION 3.16)

project(RainfallEditTest VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)


qt_add_executable(appRainfallEditTest
    main.cpp imagesUrl.qrc
)

qt_add_qml_module(appRainfallEditTest
    URI RainfallEditTest
    VERSION 1.0
    QML_FILES
        Main.qml
        QML_FILES
        QML_FILES Components/PicWindow.qml
        RESOURCES
        RESOURCES imagesUrl.qrc
        QML_FILES utils/ImageCache.js
        QML_FILES Components/PicGallery.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appRainfallEditTest PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appRainfallEditTest
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appRainfallEditTest
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appRainfallEditTest
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
