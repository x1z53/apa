/*
 * Copyright (C) 2024 Vladimir Vaskov
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 * 
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Apa.Repo {
    public async int add (
        owned ArgsHandler args_handler,
        bool skip_unknown_options = false
    ) throws CommandError, OptionsError {
        var error = new Gee.ArrayList<string> ();

        args_handler.check_args_size (false, null);

        while (true) {
            error.clear ();
            var status = yield AptRepo.add (args_handler, error, skip_unknown_options);

            if (status != ExitCode.SUCCESS && error.size > 0) {
                string error_message = normalize_error (error);
                string[] error_sources;

                switch (detect_error (error_message, out error_sources)) {
                    case OriginErrorType.NOTHING_TO_ADD_BAD_SOURCE_FORMAT:
                        throw new CommandError.COMMON (error_message);

                    case OriginErrorType.APT_REPO_UNKNOWN_SOURCE:
                        throw new CommandError.COMMON (_("Unknown source"));

                    case OriginErrorType.NONE:
                    default:
                        throw new CommandError.UNKNOWN_ERROR (error_message);
                }

            } else {
                return status;
            }
        }
    }
}
