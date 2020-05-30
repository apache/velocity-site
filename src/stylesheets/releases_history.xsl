<?xml version="1.0"?>
<!--
    Licensed to the Apache Software Foundation (ASF) under one or more
    contributor license agreements.  See the NOTICE file distributed with
    this work for additional information regarding copyright ownership.
    The ASF licenses this file to You under the Apache License, Version 2.0
    (the "License"); you may not use this file except in compliance with
    the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
  <xsl:template match="//body">
    <p>
      <table class="standard">
        <thead>
          <tr>
            <th>Version</th>
            <th>Date</th>
            <th>Description</th>
          </tr>
        </thead>
        <tbody>
          <xsl:apply-templates select="release"/>
        </tbody>
      </table>
    </p>
  </xsl:template>
  <xsl:template match="//release">
    <tr>
      <td><xsl:value-of select="@version"/></td>
      <td><xsl:value-of select="@date"/></td>
      <td><xsl:value-of select="@description"/></td>
    </tr>
  </xsl:template>  
  <xsl:template match="text()"/>
</xsl:stylesheet>
