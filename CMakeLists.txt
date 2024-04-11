cmake_minimum_required(VERSION 3.16)

project(line_chart_editor VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Charts  Quick)

qt_standard_project_setup()

qt_add_executable(appline_chart_editor
    main.cpp
)

qt_add_qml_module(appline_chart_editor
    URI line_chart_editor
    VERSION 1.0
    QML_FILES
        Main.qml
    RESOURCES
    SOURCES controller.h controller.cpp
        SOURCES
        RESOURCES .gitignore
        RESOURCES README.md
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appline_chart_editor PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appline_chart_editor
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appline_chart_editor
    PUBLIC
    Qt::Charts
    Qt::Quick
)

include(GNUInstallDirs)
install(TARGETS appline_chart_editor
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
