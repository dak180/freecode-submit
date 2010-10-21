Name: freshmeat-submit
Version: 2.1
Release: 1
URL: http://www.catb.org/~esr/freshmeat-submit/
Source0: %{name}-%{version}.tar.gz
License: BSD
Group: Applications/System
Requires: python
Summary: submit release information to freshmeat.net
BuildRoot: %{_tmppath}/%{name}-root

%description
freshmeat-submit is a script that supports remote submission of
release updates to Freshmeat via its JSON API.  It is intended for use
in project release scripts.  It reads the metadata from an
RFC-2822-like message on standard input, possibly with overrides by
command-line switches.

%prep
%setup -q

%build
echo "No build step is required."

%install
[ "$RPM_BUILD_ROOT" -a "$RPM_BUILD_ROOT" != / ] && rm -rf "$RPM_BUILD_ROOT"
mkdir -p "$RPM_BUILD_ROOT"%{_bindir}
mkdir -p "$RPM_BUILD_ROOT"%{_mandir}/man1/
cp freshmeat-submit "$RPM_BUILD_ROOT"%{_bindir}
cp freshmeat-submit.1 "$RPM_BUILD_ROOT"%{_mandir}/man1/

%clean
[ "$RPM_BUILD_ROOT" -a "$RPM_BUILD_ROOT" != / ] && rm -rf "$RPM_BUILD_ROOT"

%files
%defattr(-,root,root)
%{_mandir}/man1/freshmeat-submit.1*
%{_bindir}/freshmeat-submit

%changelog
* Wed Oct 20 2010 Eric S. Raymond <esr@snark.thyrsus.com> - 2.1-1
- Now has a query mode that can retrieve project metadata in editable form.
- Properly deletes URLs not present in your update list.
- Request withdrawal is implemented.
- License changed to BSD.

* Mon Oct 17 2010 Eric S. Raymond <esr@snark.thyrsus.com> - 2.0-1
- Updated to work with the JSON-based 3.0 freshmeat.net API.

* Mon Aug  2 2004 Eric S. Raymond <esr@snark.thyrsus.com> - 1.6-1
- Documentation and packaging fixes.

* Fri Apr 30 2004 Eric S. Raymond <esr@snark.thyrsus.com> 1.5-1
- Fix documentation bug, add note about .netrc.

* Wed Dec 31 2003 Eric S. Raymond <esr@snark.thyrsus.com> 1.4-1
- Fix bug in processing of text foci indicators.

* Mon Dec 29 2003 Eric S. Raymond <esr@snark.thyrsus.com> 1.3-1
- Fix typo affecting the RPM field.

* Wed Dec 24 2003 Eric S. Raymond <esr@snark.thyrsus.com> 1.2-1
- Add validation using the new server methods for fetching foci and license 
  types.

* Mon Dec 22 2003 Eric S. Raymond <esr@snark.thyrsus.com> 1.1-1
- Fix typos in documentation and some untested methods.


