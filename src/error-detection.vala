/*
 * Copyright 2024 Vladimir Vaskov
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Apa {

    // Should be aligned with OriginErrorType enum
    const string[] ORIGIN_ERRORS = {
        "Couldn't find package %s",
        "Package %s is a virtual package with multiple good providers.\n",
        "Unable to lock the download directory",
        "Package %s has no installation candidate",
        "Unable to fetch some archives, maybe run apt-get update or try with --fix-missing?",
        "Some index files failed to download. They have been ignored, or old ones used instead.",
        "Option some: Configuration item specification must have an =<val>.",
        "Opening configuration file some - ifstream::ifstream (2 No such file or directory)",
        "Unknown source. See `man apt-repo` for details. at /bin/apt-repo line 352.",
        "Task %s is unknown or still building at /bin/apt-repo line 260.",
        "Nothing to add: bad source format. See `man apt-repo` for details.",
        "Version %s'%s' for '%s' was not found",
        "Broken packages",
    };

    public enum OriginErrorType {
        COULDNT_FIND_PACKAGE,
        PACKAGE_VIRTUAL_WITH_MULTIPLE_GOOD_PROIDERS,
        UNABLE_TO_LOCK_DOWNLOAD_DIR,
        NO_INSTALLATION_CANDIDAT,
        UNABLE_TO_FETCH_SOME_ARCHIVES,
        SOME_INDEX_FILES_FAILED_TO_DOWNLOAD,
        CONFIGURATION_ITEM_SPECIFICATION_MUST_HAVE_AN_VAL,
        OPEN_CONFIGURATION_FILE_FAILED,
        APT_REPO_UNKNOWN_SOURCE,
        TASK_IS_UNKNOWN_OR_STILL_BUILDING,
        NOTHING_TO_ADD_BAD_SOURCE_FORMAT,
        VERSION_NOT_FOUND,
        BROKEN_PACKAGES,
        NONE,
    }

    public OriginErrorType detect_error (string error_message, out string[] error_sources = null) {
        string pattern;
        Regex regex;
        error_sources = {};

        try {
            for (int i = 0; i < ORIGIN_ERRORS.length; i++) {
                pattern = dgettext (
                    "apt",
                    ORIGIN_ERRORS[i].replace ("(", ".").replace (")", ".")
                ).strip ().replace ("%s", "(.*)");

                regex = new Regex (
                    pattern,
                    RegexCompileFlags.OPTIMIZE,
                    RegexMatchFlags.NOTEMPTY
                );

                MatchInfo match_info;
                if (regex.match (error_message, 0, out match_info)) {
                    var fetches = match_info.fetch_all ();
                    error_sources = fetches[1:fetches.length];
                    return (OriginErrorType) i;

                } else {
                    print_devel ("\nError message:     `%s'\nTranslated patern: `%s'\n".printf (error_message, pattern));
                }
            }

        } catch (Error e) {
            print_error (e.message);
        }

        return NONE;
    }

    public string normalize_error (Gee.ArrayList<string> error) {
        string error_message = "";

        for (int i = error.size - 1; i >= 0; i--) {
            if (error[i].strip () != "") {
                error_message = error[i].replace ("E: ", "").strip ();
                error.remove_at (i);
                break;

            } else {
                error.remove_at (i);
            }
        }

        for (int i = 0; i < error.size; i++) {
            if (error[i][error[i].length - 1] == '\n') {
                error[i] = error[i][0:error[i].length - 1];
            }
        }

        return error_message;
    }
}
