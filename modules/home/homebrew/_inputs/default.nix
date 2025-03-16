{
  homebrew = builtins.fetchGit {
    url = "https://github.com/Homebrew/brew";
    rev = "2f6db3757e6c8533750264c0d397c3671665e2f4";
  };

  homebrew-bundle = builtins.fetchGit {
    url = "https://github.com/Homebrew/homebrew-bundle";
    rev = "f3b381d58f4c42faf96e0a522c5b5b68f8ba1aca";
  };
}
