Summary: OCaml interface for gsl
Name: gsl-ocaml
Version: 0.6.0
Release: 1
URL: http://oandrieu.nerim.net/ocaml/#gsl
Source: %name-%version.tar.gz
License: GPL
Group: Development/Libraries
BuildRoot: %{_tmppath}/buildroot/%name-%version
Requires: gsl >= 1.9
Buildrequires: gsl-devel >= 1.9

%description
An Objective Caml / GSL interface.

%define ocamldir %(ocamlc -where)

%prep
%setup -q

%build
make

%install
rm -rf %buildroot
make DESTDIR=%buildroot INSTALLDIR=%ocamldir/gsl install
mkdir -p %buildroot/%{_infodir}
install -m 644 gsl-ocaml.info* %buildroot/%{_infodir}

%clean
rm -rf %buildroot

%post
if test -x /sbin/install-info ; then
  /sbin/install-info %{_infodir}/gsl-ocaml.info %{_infodir}/dir
fi

%preun
if test -x /sbin/install-info ; then
  /sbin/install-info --delete gsl-ocaml %{_infodir}/dir
fi

%files
%defattr(-,root,root)
%doc doc README NOTES COPYING
%ocamldir/gsl
%ocamldir/stublibs/*
%{_infodir}/*.info*

%changelog
* Fri Apr 13 2007 Olivier Andrieu <oandrieu@nerim.net> - 0.6.0-1
- Updated to 0.6.0

* Mon Oct  2 2006 Olivier Andrieu <oandrieu@nerim.net> - 0.5.0-1
- Updated to 0.5.0

* Sun Oct  1 2006 Olivier Andrieu <oandrieu@nerim.net> - 0.4.1-1
- Updated to 0.4.1

* Tue Oct 21 2003 Olivier Andrieu <oandrieu@nerim.net> 0.3.0-1
- Updated to 0.3.0

* Wed Nov 20 2002 Olivier Andrieu <oandrieu@nerim.net> 0.2-1
- Initial build.
