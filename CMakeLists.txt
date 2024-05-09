cmake_minimum_required(VERSION 3.27)

project(Client VERSION 0.1 LANGUAGES CXX)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

qt_add_executable(appClient  main.cpp)

qt_add_qml_module(appClient
    URI Client
    VERSION 1.0
    QML_FILES 
        Main.qml
    SOURCES
        tcpclient.h tcpclient.cpp
        QML_FILES LayoutLoginView.qml
        QML_FILES LayoutRegisterView.qml
        RESOURCES resource.qrc
        QML_FILES MyProfileImage.qml
        QML_FILES
        QML_FILES MyToolButton.qml
        QML_FILES MyTextField.qml
        QML_FILES MyRadioButton.qml
        QML_FILES MyShowPasswordImage.qml
        QML_FILES MyCheckImage.qml
        QML_FILES LayoutUserView.qml
        QML_FILES MyShapeLine.qml
        QML_FILES MyListView.qml
        QML_FILES MyMenuView.qml
        QML_FILES PersonalDataEditView.qml
        QML_FILES PersonalDataView.qml
        QML_FILES ChangeAvatarView.qml
        SOURCES
        SOURCES mythread.h mythread.cpp
        QML_FILES MyChatView.qml
        QML_FILES MyMsgListView.qml
        QML_FILES MyAddFriendView.qml
        QML_FILES MyCreateGroupView.qml
        QML_FILES MyGroupChatView.qml
        QML_FILES
        QML_FILES MyGroupMsgListView.qml
        QML_FILES GroupDataView.qml
        QML_FILES GroupChangeAvatarView.qml
        QML_FILES GroupDataEditView.qml
        SOURCES logo.rc
)

target_compile_features(appClient PRIVATE cxx_std_20)

set_target_properties(appClient PROPERTIES
    AUTORCC TRUE
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appClient
    PRIVATE 
        Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appClient
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)























































#qt_add_executable(Client)  //Creates and finalizes an application target of a platform-specific type.
#This command performs the following tasks:
#    1. Create a CMake target of the appropriate type for the target platform.
#    2. Link the target to the Qt::Core library.
#    3. Handle finalization of the CMake target.



# qt_standard_project_setup()     #set(CMAKE_AUTOUIC ON)  set(CMAKE_AUTOMOC ON)

# @if %{HasTranslation}
# find_package(Qt6 REQUIRED COMPONENTS Core Quick LinguistTools)
# @else
# find_package(Qt6 REQUIRED COMPONENTS Core Quick)
# @endif

# target_sources(appClient
#     PRIVATE
#         main.cpp
#         qml.qrc
#     @if %{HasTranslation}
#         %{TsFileName}
#     @endif
#         
#     PUBLIC
#         
# )

# qt_import_qml_plugins(Client)

















# cmake_minimum_required(VERSION 3.16)
# 
# project(Client VERSION 0.1 LANGUAGES CXX)
# 
# @if !true
# set(CMAKE_AUTOMOC ON)
# @endif
# set(CMAKE_CXX_STANDARD_REQUIRED ON)
# 
# find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)
# 
# @if true
# @if false
# qt_standard_project_setup(REQUIRES 6.5)
# @else
# qt_standard_project_setup()
# @endif
# @endif
# 
# qt_add_executable(appClient
#     main.cpp
# )
# 
# qt_add_qml_module(appClient
#     URI Client
#     VERSION 1.0
#     QML_FILES Main.qml
# )
# 
# # Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# # If you are developing for iOS or macOS you should consider setting an
# # explicit, fixed bundle identifier manually though.
# set_target_properties(appClient PROPERTIES
# #    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appClient
#     MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
#     MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
#     MACOSX_BUNDLE TRUE
#     WIN32_EXECUTABLE TRUE
# )
# 
# target_link_libraries(appClient
#     PRIVATE Qt6::Quick
# )
# 
# include(GNUInstallDirs)
# install(TARGETS appClient
#     BUNDLE DESTINATION .
#     LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
#     RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
# )
