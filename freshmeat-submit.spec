Name: freshmeat-submit
Version: 1.3
Release: 1
URL: http://www.catb.org/~esr/freshmeat-submit/
Source0: %{name}-%{version}.tar.gz
License: GPL 
Group: Applications/System
Requires: python
Summary: submit release information to freshmeat.net
%undefine __check_files

%description
freshmeat-submit is a script that supports remote submission of
release updates to Freshmeat via its XML-RPC interface.  It is
intended for use in project release scripts.  It reads the metadata
from an RFC-2822-like message on standard input, possibly with
overrides by command-line switches.

%prep
%setup -q

%build
echo "No build step is required."

%install
rm -rf $RPM_BUILD_ROOT
make install

%clean
rm -rf $RPM_BUILD_ROOT

%changelog

* Wed Dec 24 2003 Eric S. Raymond <esr@snark.thyrsus.com> 
- Add validation using the new server methods for fetching foci and license 
  types.

* Mon Dec 22 2003 Eric S. Raymond <esr@snark.thyrsus.com> 
- Fix typos in documentation and some untested methods.

%files
%defattr(-,root,root)
/usr/share/man/man1/freshmeat-submit.1
/usr/bin/freshmeat-submit


