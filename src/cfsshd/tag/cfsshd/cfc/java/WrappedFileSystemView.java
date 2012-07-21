/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

import org.apache.sshd.server.SshFile;
import org.apache.sshd.server.FileSystemView;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;

/**
 * wrapped filesystem view to set a different root, etc.
 * @author denny valliant
 */
public class WrappedFileSystemView implements FileSystemView {

    private final Logger LOG = LoggerFactory.getLogger(WrappedFileSystemView.class);


    // the first and the last character will always be '/'
    // It is always with respect to the root directory.
    private String currDir;

    private String userName;

    private boolean caseInsensitive = false;

    /**
     * Constructor - internal do not use directly, use {@link NativeFileSystemFactory} instead
     */
    protected WrappedFileSystemView(String userName) {
        this(userName, false);
    }

    /**
     * Constructor - internal do not use directly, use {@link NativeFileSystemFactory} instead
     */
    public WrappedFileSystemView(String userName, boolean caseInsensitive) {
        if (userName == null) {
            throw new IllegalArgumentException("user can not be null");
        }

        this.caseInsensitive = caseInsensitive;

        currDir = System.getProperty("user.dir");
        this.userName = userName;

        // add last '/' if necessary
        LOG.debug("Native filesystem view created for user \"{}\" with root \"{}\"", userName, currDir);
    }

    /**
     * Get file object.
     */
    public SshFile getFile(String file) {
        return getFile(currDir, file);
    }

    public SshFile getFile(SshFile baseDir, String file) {
        return getFile(baseDir.getAbsolutePath(), file);
    }

    protected SshFile getFile(String dir, String file) {
        // get actual file object
        String physicalName = WrappedSshFile.getPhysicalName("/",
                dir, file, caseInsensitive);
        File fileObj = new File(physicalName);

        // strip the root directory and return
        String userFileName = physicalName.substring("/".length() - 1);
        return new WrappedSshFile(userFileName, fileObj, userName);
    }
}
