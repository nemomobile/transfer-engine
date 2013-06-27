Name: nemo-transferengine
Version: 0.0.17
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
Requires: libnemotransferengine = %{version}

%description
%{summary}

%package -n libnemotransferengine
Summary: Transfer engine library.
Group: Development/Libraries
Requires: nemo-transferengine-qt5

%description -n libnemotransferengine
%{summary}

%files -n libnemotransferengine
%defattr(-,root,root,-)
%{_libdir}/*.so.*

%package -n libnemotransferengine-devel
Summary: Development headers for transfer engine library.
Group: Development/Libraries
Requires: libnemotransferengine = %{version}

%description -n libnemotransferengine-devel
%{summary}

%files -n libnemotransferengine-devel
%defattr(-,root,root,-)
%{_libdir}/*.so
%{_includedir}/TransferEngine/*.h
%{_qt_datadir}/mkspecs/features/nemotransferengine-plugin.prf
%{_libdir}/pkgconfig/nemotransferengine.pc

%package tests
Summary:   Unit tests for Nemo TransferEngine
License:   LGPLv2.1
Group:     System Environment/Daemon

%description tests
Unit tests for Nemo TransferEngine

%files tests
%defattr(-,root,root,-)
/opt/tests/nemo-transfer-engine/*


%prep
%setup -q -n %{name}-%{version}

%build

%qmake

make %{?jobs:-j%jobs}

%install
rm -rf %{buildroot}
%qmake_install

%post -n libnemotransferengine
/sbin/ldconfig

%postun -n libnemotransferengine
/sbin/ldconfig
