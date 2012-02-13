# Generated from rb-mailnotify-0.1.gem by gem2rpm -*- rpm-spec -*-
%global gemname rb-mailnotify

%global gemdir %(ruby -rubygems -e 'puts Gem::dir' 2>/dev/null)
%global geminstdir %{gemdir}/gems/%{gemname}-%{version}
%global rubyabi 1.8

Summary: mail notification-ish tools
Name: rubygem-%{gemname}
Version: 0.2
Release: 1%{?dist}
Group: Development/Languages
License: MIT
Source0: http://file.rdu.redhat.com/~vbatts/gems/%{gemname}-%{version}.gem
#Source1: %{gemname}-%{version}.tar.gz
Requires: ruby(abi) = %{rubyabi}
Requires: ruby(rubygems) 
Requires: ruby 
Requires: rubygem(libnotifymaildirrb-inotify) 
BuildRequires: ruby(abi) = %{rubyabi}
BuildRequires: ruby(rubygems) 
BuildRequires: ruby 
BuildArch: noarch
Provides: rubygem(%{gemname}) = %{version}

%description
mail notification-ish tools


%package doc
Summary: Documentation for %{name}
Group: Documentation
Requires: %{name} = %{version}-%{release}
BuildArch: noarch

%description doc
Documentation for %{name}


%prep
%setup -q -c -T
mkdir -p .%{gemdir}
gem install --local --install-dir .%{gemdir} \
            --bindir .%{_bindir} \
            --force %{SOURCE0}

%build

%install
mkdir -p %{buildroot}%{gemdir}
cp -a .%{gemdir}/* \
        %{buildroot}%{gemdir}/

mkdir -p %{buildroot}%{_bindir}
cp -a .%{_bindir}/* \
        %{buildroot}%{_bindir}/

find %{buildroot}%{geminstdir}/bin -type f | xargs chmod a+x

%files
%dir %{geminstdir}
%{_bindir}/riff
%{_bindir}/mailnotify
%{geminstdir}/bin
%{geminstdir}/lib
%{geminstdir}/README.rdoc
%exclude %{gemdir}/cache/%{gemname}-%{version}.gem
%{gemdir}/specifications/%{gemname}-%{version}.gemspec

%files doc
%doc %{gemdir}/doc/%{gemname}-%{version}


%changelog
* Fri Feb 10 2012 Vincent Batts <vbatts@redhat.com> 0.1-1
- new package built with tito

* Fri Feb 10 2012 Vincent Batts - 0.1-1
- Initial package
