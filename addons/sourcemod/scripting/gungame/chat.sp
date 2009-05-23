/**
 * ===============================================================
 * GunGame:SM, Copyright (C) 2007
 * All rights reserved.
 * ===============
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 *
 * To view the latest information, see: http://www.hat-city.net/
 * Author(s): teame06
 *
 * This was also brought to you by faluco and the hat (http://www.hat-city.net/haha.jpg)
 *
 * Credit:
 * Original Idea and concepts of Gun Game was made by cagemonkey @ http://www.cagemonkey.org
 *
 * Especially would like to thank BAILOPAN for everything.
 * Also faluco for listening to my yapping.
 * Custom Mutliple Kills Per Level setting was an idea from XxAvalanchexX GunGame 1.6.
 * To the SourceMod Dev Team for making a nicely design system for this plugin to be recreated it.
 * FlyingMongoose for slaping my ideas away and now we have none left ... Geez.
 * I would also like to thank sawce with ^^.
 * Another person who I would like to thank is OneEyed.
 */

stock CHAT_SayText2(client, author, const String:message[])
{
    new Handle:buffer = StartMessageOne("SayText2", client);
    if ( buffer != INVALID_HANDLE )
    {
        BfWriteByte(buffer, author);
        BfWriteByte(buffer, true);
        BfWriteString(buffer, message);
        EndMessage();
    }
}  

stock CHAT_SayText2ToAll(author, const String:message[])
{
    new Handle:buffer = StartMessageAll("SayText2");
    if ( buffer != INVALID_HANDLE )
    {
        BfWriteByte(buffer, author);
        BfWriteByte(buffer, true);
        BfWriteString(buffer, message);
        EndMessage();
    }
}  

stock CHAT_SayText(client, author, const String:msg[])
{
    if ( !isColorMsg || !author )
    {
        if ( client )
        {
            PrintToChat(client, msg);
            return;
        }
        PrintToChatAll(msg);
        return;
    }
    new String:cmsg[192] = "\x1";
    StrCat(cmsg, sizeof(cmsg), msg);
    if ( client )
    {
        CHAT_SayText2(client, author, cmsg);
        return;
    }
    CHAT_SayText2ToAll(author, cmsg);
    return;
}

stock CHAT_DetectColorMsg()
{
    decl String:gameName[64];
    GetGameFolderName(gameName, sizeof(gameName));

    isColorMsg = false;
    if ( StrEqual(gameName, "cstrike") )
    {
        isColorMsg = true;
        return;
    }
    if ( StrEqual(gameName, "tf") )
    {
        isColorMsg = true;
        return;
    }
}
