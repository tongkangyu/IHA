cmake_minimum_required(VERSION 3.16)

project(IHA VERSION 0.1.18 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2)

qt_policy(SET QTP0001 NEW)

qt_add_executable(appIHA
    main.cpp
)

qt_add_qml_module(appIHA
    URI IHA
    VERSION 1.0
    QML_FILES
        Main.qml
        qml/Theme.qml
        qml/components/Card.qml
        qml/components/Button.qml
        qml/components/AnimatedProgressBar.qml
        qml/components/AnimatedListItem.qml
        qml/pages/HealthPage.qml
        qml/pages/AssistantPage.qml
        qml/pages/DevicePage.qml
        qml/pages/ProfilePage.qml
        qml/pages/details/StepsDetailPage.qml
        qml/pages/details/SleepDetailPage.qml
        qml/pages/details/HeartRateDetailPage.qml
        qml/pages/details/CaloriesDetailPage.qml
        qml/pages/details/ActivityDetailPage.qml
        qml/pages/details/ActivityCountDetailPage.qml
        qml/pages/settings/AppSettingsPage.qml
        qml/pages/settings/AboutPage.qml
        qml/pages/settings/ProfileInfoPage.qml
)

set_target_properties(appIHA PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
)

target_link_libraries(appIHA
    PRIVATE Qt6::Quick Qt6::QuickControls2
)

include(GNUInstallDirs)
install(TARGETS appIHA
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
