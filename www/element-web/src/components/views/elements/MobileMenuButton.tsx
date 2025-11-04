/*
Copyright 2024 New Vector Ltd.

SPDX-License-Identifier: AGPL-3.0-only OR GPL-3.0-only OR LicenseRef-Element-Commercial
Please see LICENSE files in the repository root for full details.
*/

import React, { type JSX } from "react";
import { IconButton, Tooltip } from "@vector-im/compound-web";
import classNames from "classnames";

import { _t } from "../../../languageHandler";
import defaultDispatcher from "../../../dispatcher/dispatcher";

interface IProps {
    className?: string;
}

/**
 * Mobile hamburger menu button to toggle left panel
 */
export default function MobileMenuButton({ className }: IProps): JSX.Element {
    const handleClick = (): void => {
        // Toggle left panel by dispatching custom action
        defaultDispatcher.dispatch({
            action: "toggle_mobile_left_panel",
        });
    };

    return (
        <Tooltip label={_t("action|menu")}>
            <IconButton
                className={classNames("mx_MobileMenuButton", className)}
                onClick={handleClick}
                aria-label={_t("action|menu")}
            >
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path
                        d="M3 12H21M3 6H21M3 18H21"
                        stroke="currentColor"
                        strokeWidth="2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                    />
                </svg>
            </IconButton>
        </Tooltip>
    );
}

