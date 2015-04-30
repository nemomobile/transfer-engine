Name: transfer-engine-qt5
Version: 0.0.34
Release: 0
Summary: Transfer Engine for uploading media content and tracking transfers.
Group: System Environment/Daemon
License: LGPLv2.1
URL: https://github.com/nemomobile/transfer-engine
Source0: %{name}-%{version}.tar.gz
BuildRequires: pkgconfig(Qt5Core)
BuildRequires: pkgconfig(Qt5DBus)
BuildRequires: pkgconfig(Qt5Sql)
BuildRequires: pkgconfig(Qt5Test)
BuildRequires: pkgconfig(Qt5Qml)
BuildRequires: pkgconfig(Qt5Quick)
BuildRequires: pkgconfig(accounts-qt5)
BuildRequires: desktop-file-utils
BuildRequires: pkgconfig(quillmetadata-qt5)
BuildRequires: pkgconfig(nemonotifications-qt5) >= 1.0.4
BuildRequires: qt5-qttools-linguist
BuildRequires: qt5-qttools-qthelp-devel
BuildRequires: qt5-plugin-platform-minimal
BuildRequires: qt5-plugin-sqldriver-sqlite
BuildRequires: pkgconfig(qt5-boostable)
Requires: libnemotransferengine-qt5 = %{version}
Provides: transfer-engine-qt5
Obsoletes: nemo-transferengine-qt5
Obsoletes: nemo-transferengine

%description
%{summary}

%files
%defattr(-,root,root,-)
%{_libdir}/systemd/user/transferengine.service
%dir %{_datadir}/nemo-transferengine
%{_bindir}/nemo-transfer-engine
%{_datadir}/dbus-1/services/org.nemo.transferengine.service
%{_datadir}/translations/nemo-transfer-engine_eng_en.qm
%{_datadir}/lipstick/notificationcategories/*

%package -n libnemotransferengine-qt5
Summary: Transfer engine library.
Group: Development/Libraries

%description -n libnemotransferengine-qt5
%{summary}

%files -n libnemotransferengine-qt5
%defattr(-,root,root,-)
%{_libdir}/*.so.*
%{_libdir}/qt5/qml/org/nemomobile/transferengine/*

%package -n libnemotransferengine-qt5-devel
Summary: Development headers for transfer engine library.
Group: Development/Libraries
Requires: libnemotransferengine-qt5 = %{version}

%description -n libnemotransferengine-qt5-devel
%{summary}

%files -n libnemotransferengine-qt5-devel
%defattr(-,root,root,-)
%{_libdir}/*.so
%{_includedir}/TransferEngine-qt5/*.h
%{_datadir}/qt5/mkspecs/features/nemotransferengine-plugin-qt5.prf
%{_libdir}/pkgconfig/nemotransferengine-qt5.pc

%package ts-devel
Summary:   Translation source for Nemo TransferEngine
License:   LGPLv2.1
Group:     System Environment/Daemon
Provides: transfer-engine-qt5-ts-devel
Obsoletes: nemo-transferengine-qt5-ts-devel
Obsoletes: nemo-transferengine-ts-devel

%description ts-devel
Translation source for Nemo TransferEngine

%files ts-devel
%defattr(-,root,root,-)
%{_datadir}/translations/source/nemo-transfer-engine.ts

%package tests
Summary:   Unit tests for Nemo TransferEngine
License:   LGPLv2.1
Group:     System Environment/Daemon
Provides: transfer-engine-qt5-tests
Obsoletes: nemo-transferengine-qt5-tests
Obsoletes: nemo-transferengine-tests

%description tests
Unit tests for Nemo TransferEngine

%files tests
%defattr(-,root,root,-)
/opt/tests/nemo-transfer-engine-qt5/*

%package doc
Summary:   Documentation for Nemo TransferEngine
License:   BSD
Group:     System Environment/Daemon
Provides: transfer-engine-qt5-doc
Obsoletes: nemo-transferengine-qt5-doc
Obsoletes: nemo-transferengine-doc

%description doc
Documentation for Nemo TransferEngine

%files doc
%defattr(-,root,root,-)
%{_datadir}/doc/transfer-engine-qt5/*



%prep
%setup -q -n %{name}-%{version}

%build

%qmake5

make %{?jobs:-j%jobs}
make docs

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/%{_datadir}/nemo-transferengine
%qmake5_install

mkdir -p %{buildroot}/%{_docdir}/%{name}
cp -R doc/html/* %{buildroot}/%{_docdir}/%{name}/

%define def_uid $(grep "^UID_MIN" /etc/login.defs |  tr -s " " | cut -d " " -f2)
%define def_user $(getent passwd %def_uid | sed 's/:.*//')
%define db_file /home/%{def_user}/.local/nemo-transferengine/transferdb.sqlite
%define te_pid $(pgrep -f nemo-transfer-engine)

%post -n libnemotransferengine-qt5
/sbin/ldconfig

%post -n transfer-engine-qt5
if [ -n "%{te_pid}" ]
then
    kill -s 10 %{te_pid}
fi

exit 0

%postun -n libnemotransferengine-qt5
/sbin/ldconfig

