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

namespace Apa.Task.Data {

    public const string OPTION_BY_PACKAGE_SHORT = "-p";
    public const string OPTION_BY_PACKAGE_LONG = "--by-package";

    public OptionEntity?[] search_options () {
        return {
            {
                OPTION_BY_PACKAGE_SHORT, OPTION_BY_PACKAGE_LONG,
                null,
                Descriptions.option_by_package ()
            },
        };
    }

    public const string OPTION_OWNER_SHORT = "-o";
    public const string OPTION_OWNER_LONG = "--owner";
    public const string OPTION_BRANCH_SHORT = "-b";
    public const string OPTION_BRANCH_LONG = "--branch";
    public const string OPTION_STATE_SHORT = "-s";
    public const string OPTION_STATE_LONG = "--state";

    public OptionEntity?[] search_arg_options () {
        return {
            {
                OPTION_OWNER_SHORT, OPTION_OWNER_LONG,
                null,
                Descriptions.arg_option_owner ()
            },
            {
                OPTION_BRANCH_SHORT, OPTION_BRANCH_LONG,
                null,
                Descriptions.arg_option_branch ()
            },
            {
                OPTION_STATE_SHORT, OPTION_STATE_LONG,
                null,
                Descriptions.arg_option_state ()
            },
        };
    }

    public OptionEntity?[] show_options () {
        return {};
    }

    public OptionEntity?[] show_arg_options () {
        return {};
    }
}
