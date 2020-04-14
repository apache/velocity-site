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
  <xsl:template match="//release">
    <h3>
      <xsl:text>Release </xsl:text>
      <xsl:value-of select="@version"/>
      <xsl:text> - </xsl:text>
      <xsl:value-of select="@date"/>
    </h3>
    <p>
      <table class="standard">
        <thead>
          <tr>
            <th>Type</th>
            <th>Changes</th>
            <th>Bye</th>
          </tr>
        </thead>
        <tbody>
          <xsl:apply-templates select="action"/>
        </tbody>
      </table>
    </p>
  </xsl:template>
  <xsl:template match="//action">
    <tr>
      <td>
        <xsl:choose>
          <xsl:when test="@type='add'">
            <img src="images/add.png"/>
          </xsl:when>
          <xsl:when test="@type='fix'">
            <img src="images/fix.png"/>
          </xsl:when>
        </xsl:choose>
      </td>
      <td>
        <xsl:apply-templates select="node()" mode="nospace"/>
<!--        <xsl:value-of select="normalize-space()"/>-->
        <xsl:text>. </xsl:text>
        <xsl:if test="@issue">
          <xsl:text>Fixes </xsl:text>
          <a href="https://issues.apache.org/jira/browse/{@issue}">
            <xsl:value-of select="@issue"/>
          </a>
          <xsl:text>. </xsl:text>
        </xsl:if>
        <xsl:if test="@due-to">
          <xsl:text>Thanks to </xsl:text>
          <xsl:value-of select="@due-to"/>
          <xsl:text>.</xsl:text>
        </xsl:if>
      </td>
      <td>
        <xsl:value-of select="@dev"/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="text()" mode="nospace" priority="1" >
    <xsl:text> </xsl:text>
    <xsl:value-of select="normalize-space(.)" />
    <xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="node() | @*" mode="nospace">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*" mode="nospace" />
    </xsl:copy>
  </xsl:template>
  <xsl:template match="text()"/>
</xsl:stylesheet>
