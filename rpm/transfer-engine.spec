Name: nemo-transferengine
Version: 0.0.14
Release: 0
Summary: Transfer Engine for uploading media content and tracking transfers.
Group: System Environment/Daemon
License: LGPLv2.1
URL: https://github.com/nemomobile/transfer-engine
Source0: %{name}-%{version}.tar.gz
BuildRequires: pkgconfig(QtCore)
BuildRequires: pkgconfig(accounts-qt)
BuildRequires: pkgconfig(QtSystemInfo)
BuildRequires: desktop-file-utils
BuildRequires: pkgconfig(mlite)
BuildRequires: pkgconfig(accounts-qt)
BuildRequires: pkgconfig(quillmetadata)
BuildRequires: qt-devel-tools

%description
%{summary}.

%files
%defattr(-,root,root,-)
%dir %{_datadir}/nemo-transferengine
%{_libdir}/*.so*
%{_bindir}/nemo-transfer-engine
%{_datadir}/dbus-1/services/org.nemo.transferengine.service
%{_datadir}/translations/nemo-transfer-engine_eng_en.qm



%package -n nemo-transferengine-devel
Summary: Development headers for transfer engine library.
Group: Development/Libraries
Requires: nemo-transferengine = %{version}

%description -n nemo-transferengine-devel
%{summary}.

%files -n nemo-transferengine-devel
%defattr(-,root,root,-)
%{_includedir}/TransferEngine/*.h
%{_qt_datadir}/mkspecs/features/nemotransferengine-plugin.prf
%{_libdir}/pkgconfig/nemotransferengine.pc

%package ts-devel
Summary:   Translation source for Nemo TransferEngine
License:   LGPLv2.1
Group:     System Environment/Daemon

%description ts-devel
Translation source for Nemo TransferEngine

%files ts-devel
%defattr(-,root,root,-)
%{_datadir}/translations/source/nemo-transfer-engine.ts

%package tests
Summary:   Unit tests for Nemo TransferEngine
License:   LGPLv2.1
Group:     System Environment/Daemon

%description tests
Unit tests for Nemo TransferEngine

%files tests
%defattr(-,root,root,-)
/opt/tests/nemo-transfer-engine/*

%package doc
Summary:   Documentation for Nemo TransferEngine
License:   BSD
Group:     System Environment/Daemon

%description doc
Documentation for Nemo TransferEngine

%files doc
%defattr(-,root,root,-)
/usr/share/doc/nemo-transfer-engine/*



%prep
%setup -q -n %{name}-%{version}

%build

%qmake

make %{?jobs:-j%jobs}
make docs

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/%{_datadir}/nemo-transferengine
%qmake_install

%define def_uid $(grep "^UID_MIN" /etc/login.defs |  tr -s " " | cut -d " " -f2)
%define def_user $(getent passwd %def_uid | sed 's/:.*//')
%define db_file /home/%{def_user}/.local/nemo-transferengine/transferdb.sqlite
%define te_pid $(pgrep -f nemo-transfer-engine)

%post -n nemo-transferengine
/sbin/ldconfig
if [ -n "%{te_pid}" ]
then
    kill -s 10 %{te_pid}
fi

exit 0

%postun -n nemo-transferengine
/sbin/ldconfig

if [ -f "%{db_file}" ]
then
    rm %{db_file}
fi
exit 0
